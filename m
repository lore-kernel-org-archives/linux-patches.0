Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047495;
	b=TF/Q4UceciEYw3xB1d0lNCKdmb4AAht6+7mrrgqu6Q/WaZOzMUY1bH0ix1pg+gy/fq0X
	 ZOWSCSsDKaMzJQe3RtZLrm2Hn4kzvAxzBIW16zSRlTytmy5An4AGmBQnMYITWNCG6yP6o
	 e7AiNsFaRr3Cjhrml33HqQjRnUlM4Eiu9tTnLYFnJ5v1DSMIl6sLrtk9mvavTfZpbDxyo
	 IovEehes4Xoz4tZXeBO7XQyQv5oxEPdJeX7ibbEfKdhn+r3pmCAzDJv9j6LjnKuKCTqvQ
	 9Hz6GmnUeyAh2jb6LBMxVFptYAMa1X/XynzXl8U2nxpD9aFo+4+wcAHxel9omh/S4KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kzHGimg3IuyYu22/DtzWmYAOmNxVpifiIhEKjH2nJy0=;
	b=hRwmDScMGO9rKZhLEcxuby7Gi1NOEOLj4ZHLW69uiMz6eR+rDB39QzVi6Qyer/y54oyN
	 KJ8CVHW1x54/X+I4VVeoivakfRplJxezfWSGwFx2YqsxR0jYGoNcr/5dH3zVCxg8gxgMa
	 2w1lcm+JMBxpEn+5r6wQNkQe0kni2dheFtAJ8R2fLbBWakwYbSYc8Tktx+s2WbJaa6XQ+
	 noJRbRGFtcOrLm9uL7GgXQKG4E/XhRg5m2DdzgiCltIRUoPKWqIV045XqNgqUsWcdfIOh
	 jiLfsjYsh7zKLazaFnKvBo/0kuRycgjtms6WZ9kDs3+QdrcozAqfKrNsb2MokF5LDLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiSh7i+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9BB606A320;
	Thu, 19 Nov 2026 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiSh7i+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696831F000C4;
	Thu, 19 Nov 2026 00:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047494;
	bh=kzHGimg3IuyYu22/DtzWmYAOmNxVpifiIhEKjH2nJy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiSh7i+2qDADHJHYaVi37diSmwbyir6H3dDuOeUy8WvPfmS+bRv+NwNSsOmmkB78O
	 /IwVFA//eNFGahia3HnUxTNIiTHYPyoFg5d+ahbyAbwM9wQVmhGj1eg1NZYmfzZ/6W
	 KLMcA8bvi1JIkc4xPWGXqMTwkiuP+lRPHNhYyJP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1659/2857] scsi: target: Fix LUN/device R/W and total command stats
Date: Wed, 18 Nov 2026 15:44:53 +0100
Message-ID: <20261118150301.062350756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 95aa2041c654161d1b5c1eca5379d67d91ef1cf2 ]

In commit 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
I saw we sometimes use %u and also misread the spec. As a result I
thought all the stats were supposed to be 32-bit only. However, for the
majority of cases we support currently, the spec specifies u64 bit
stats. This patch converts the stats changed in the commit above to u64.

Fixes: 9cf2317b795d ("scsi: target: Move I/O path stats to per CPU")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Link: https://patch.msgid.link/20250917221338.14813-2-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_stat.c | 24 ++++++++++++------------
 include/target/target_core_base.h | 12 ++++++------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 57ec5e3d4e941..3e20fcb2bb7d3 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -282,7 +282,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -290,7 +290,7 @@ static ssize_t target_stat_lu_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiLuNumCommands */
-	return snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	return snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 }
 
 static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
@@ -299,7 +299,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -307,7 +307,7 @@ static ssize_t target_stat_lu_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuReadMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
@@ -316,7 +316,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	struct se_device *dev = to_stat_lu_dev(item);
 	struct se_dev_io_stats *stats;
 	unsigned int cpu;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	for_each_possible_cpu(cpu) {
 		stats = per_cpu_ptr(dev->stats, cpu);
@@ -324,7 +324,7 @@ static ssize_t target_stat_lu_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiLuWrittenMegaBytes */
-	return snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	return snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 }
 
 static ssize_t target_stat_lu_resets_show(struct config_item *item, char *page)
@@ -1044,7 +1044,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 cmds = 0;
+	u64 cmds = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1059,7 +1059,7 @@ static ssize_t target_stat_auth_num_cmds_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", cmds);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", cmds);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1073,7 +1073,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1088,7 +1088,7 @@ static ssize_t target_stat_auth_read_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
@@ -1102,7 +1102,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	struct se_dev_entry *deve;
 	unsigned int cpu;
 	ssize_t ret;
-	u32 bytes = 0;
+	u64 bytes = 0;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
@@ -1117,7 +1117,7 @@ static ssize_t target_stat_auth_write_mbytes_show(struct config_item *item,
 	}
 
 	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", bytes >> 20);
+	ret = snprintf(page, PAGE_SIZE, "%llu\n", bytes >> 20);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 70ea2748df2bf..e687859e28c79 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -659,9 +659,9 @@ struct se_lun_acl {
 };
 
 struct se_dev_entry_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_dev_entry {
@@ -795,9 +795,9 @@ struct se_device_queue {
 };
 
 struct se_dev_io_stats {
-	u32			total_cmds;
-	u32			read_bytes;
-	u32			write_bytes;
+	u64			total_cmds;
+	u64			read_bytes;
+	u64			write_bytes;
 };
 
 struct se_device {
-- 
2.53.0



