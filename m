Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE3A1849DD;
	Tue, 18 Jun 2024 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715595; cv=none; b=tpVTAxfkHr7DJ/9F6lAfGpoFDGiRqVXqv3gWiRe/bUaJx8u2I9KXmAsqllp8PT+ZjfmTbsVm7idRJWeQQolG+dZS3gfCh4rrXp3uJsihhIOBhP5944E7LS4UCyba/Mp4A/9pmLNDQZ7DnGU5m9pQ3kvjblNcdlNSp5a9HxPoDeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715595; c=relaxed/simple;
	bh=YIpe/nAc0bU4oXJLGCHW7sPM+PgG6wvdEVkNP/tM8ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fO/AO2QGyCX6OscPx4XJ9v20xuz/89f6sJ6LskujKrQmI92MGJM4R7n1x8xNfyH334Lr4xcdBaon8L5TW5PLJ/sDny/mO9iq0Qq5VLR42PjAO1zKykWl27qpA2Cg4IAqN/RiNANmHSZrUynO203KMkz7Pp3Ev1Avms7bpRE43V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGRmG4ZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGRmG4ZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7294FC4AF48;
	Tue, 18 Jun 2024 12:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715594;
	bh=YIpe/nAc0bU4oXJLGCHW7sPM+PgG6wvdEVkNP/tM8ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGRmG4ZXTTRFH0FHVSUJu0HwVsJi9e/vlmWh1u7oOc5keZEpXyrZjmI8YqsAbXtHL
	 ufdzxqrz1mIgpJuQ9eum2PxLc0k6axSR+n8C/x70J6kID7e0XrHgj4ZEc4lVkcTM6O
	 OjkpToNqyJCfuZEhuLePhUagwa4isKn37O2ADsg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pan Xinhui <xinhui@linux.vnet.ibm.com>,
	Jia He <hejianet@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 344/770] sysctl: introduce new proc handler proc_dobool
Date: Tue, 18 Jun 2024 14:33:17 +0200
Message-ID: <20240618123420.541491399@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia He <hejianet@gmail.com>

[ Upstream commit a2071573d6346819cc4e5787b4206f2184985160 ]

This is to let bool variable could be correctly displayed in
big/little endian sysctl procfs. sizeof(bool) is arch dependent,
proc_dobool should work in all arches.

Suggested-by: Pan Xinhui <xinhui@linux.vnet.ibm.com>
Signed-off-by: Jia He <hejianet@gmail.com>
[thuth: rebased the patch to the current kernel version]
Signed-off-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sysctl.h |  2 ++
 kernel/sysctl.c        | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index c202a72e16906..47cf70c8eb93c 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -55,6 +55,8 @@ typedef int proc_handler(struct ctl_table *ctl, int write, void *buffer,
 		size_t *lenp, loff_t *ppos);
 
 int proc_dostring(struct ctl_table *, int, void *, size_t *, loff_t *);
+int proc_dobool(struct ctl_table *table, int write, void *buffer,
+		size_t *lenp, loff_t *ppos);
 int proc_dointvec(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_douintvec(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_minmax(struct ctl_table *, int, void *, size_t *, loff_t *);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b29a9568ebbe4..abe0f16d53641 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -546,6 +546,21 @@ static void proc_put_char(void **buf, size_t *size, char c)
 	}
 }
 
+static int do_proc_dobool_conv(bool *negp, unsigned long *lvalp,
+				int *valp,
+				int write, void *data)
+{
+	if (write) {
+		*(bool *)valp = *lvalp;
+	} else {
+		int val = *(bool *)valp;
+
+		*lvalp = (unsigned long)val;
+		*negp = false;
+	}
+	return 0;
+}
+
 static int do_proc_dointvec_conv(bool *negp, unsigned long *lvalp,
 				 int *valp,
 				 int write, void *data)
@@ -808,6 +823,26 @@ static int do_proc_douintvec(struct ctl_table *table, int write,
 				   buffer, lenp, ppos, conv, data);
 }
 
+/**
+ * proc_dobool - read/write a bool
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
+ * values from/to the user buffer, treated as an ASCII string.
+ *
+ * Returns 0 on success.
+ */
+int proc_dobool(struct ctl_table *table, int write, void *buffer,
+		size_t *lenp, loff_t *ppos)
+{
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_dobool_conv, NULL);
+}
+
 /**
  * proc_dointvec - read a vector of integers
  * @table: the sysctl table
@@ -1644,6 +1679,12 @@ int proc_dostring(struct ctl_table *table, int write,
 	return -ENOSYS;
 }
 
+int proc_dobool(struct ctl_table *table, int write,
+		void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -3503,6 +3544,7 @@ int __init sysctl_init(void)
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
  */
+EXPORT_SYMBOL(proc_dobool);
 EXPORT_SYMBOL(proc_dointvec);
 EXPORT_SYMBOL(proc_douintvec);
 EXPORT_SYMBOL(proc_dointvec_jiffies);
-- 
2.43.0



