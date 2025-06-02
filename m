Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19F923717C;
	Mon,  2 Jun 2025 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876807; cv=none; b=QBXqLZRLixNGoRjD93SH74QByofuKTuKHAkXe2mB9qwgpob2ypi+u2bDPgAtHSYlqiMtyjcXgOlp+JFGwGVPCoHDXTjUdefXAgBTU1r35Zb9lmI1+VIfvueohHZmddAf4Vn3y/NLn8JPL2Ee5SXYvaLVe3SFwXDnl0qXqV53Bfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876807; c=relaxed/simple;
	bh=gGdSpHXTYTyn9dpB70LlQMpp7dJ5a8x7lOTZyuGpejw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1UO2KmFP3ZDWa716HzRwxKl3NHbEaqhjSqP5nLmeA/RBGIL6Nx/MyTlyckfzBbFIzSqRDXhRxrc9o20PcywIBgyTA+iEamZWSOaRoAJ/dzQ1sa8n2C+7kOCw7OgnP7bmbX8JkZPfe2JksGwuHOQIe4KTA3dRPepvGGO7b3thhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxhjH+j4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxhjH+j4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE84C4CEEB;
	Mon,  2 Jun 2025 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876807;
	bh=gGdSpHXTYTyn9dpB70LlQMpp7dJ5a8x7lOTZyuGpejw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxhjH+j4T4q2o4Nte6lFn4fBGwXKpnFS0WUKlUN1Aslljg7rre61KkjxyA7P5ztIK
	 +SKYto8WFCJkkTgllcXa2K4XWWg0wNcDWUG9BNAeUOE9u+VkljF4WkkmeXicVeyvlo
	 SkkNHnMIXSRYEUluafc4tOzplx9GuCnhe144BqyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/325] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  2 Jun 2025 15:45:49 +0200
Message-ID: <20250602134322.753336680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 45fc728515c14f53f6205789de5bfd72a95af3b8 ]

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a20cf54d12dca..8b23b8bc5a036 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -671,6 +671,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {
-- 
2.39.5



