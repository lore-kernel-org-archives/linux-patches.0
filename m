Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2803B13C3D8;
	Thu, 23 May 2024 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470781; cv=none; b=p6fcNixeDRgCJzriR+VDs/3INstHeHSdpEtomABOp8XAzc+SiwvmB00HTWRTkP5Qvzzbi3MuUcCJpTOZRKVXViyExH8O0L5GdlJ0KfxG0kLP/F9weJopy0WE2wT3ih/pMvlsd6ho5YSuifiwkLlPNGoErGPDzR+h1k2KV51W9mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470781; c=relaxed/simple;
	bh=nU4w30vDKyKP9JGURPcF04Hz0RprMAxhYOL3K1tO350=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTtksZsFYGzwURuHvZR5VUFFAUql6qEJNr3aImeYn5lFBnZD3Qc/9J2O1bSEqtYm2McQIn2pc4OArm5rwa1JoqT1rNCQnVameKGyIQJwlZYOjkLAqJKttpWYePHm8jIz9WkHLHonlC/1jrdPJITNch+ZbOyFV2F8p7XRz7xDml4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTVEt5/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTVEt5/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C36C2BD10;
	Thu, 23 May 2024 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470781;
	bh=nU4w30vDKyKP9JGURPcF04Hz0RprMAxhYOL3K1tO350=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTVEt5/LRce5KIC97j/JzQkWCK5sImsMwH7+DdgYqGeW4Uo3/J0xV2oAUdpfadlRp
	 Ug7Wt7zr6u/P0fEPHnQlIiJ9WwvVaI7goknx+CL0+EDkbJ2say8+GxO5cTut40EQgx
	 5CxUD/OtvOK2/oSx9uzUyDy9yZbVNhbupMfOo4Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/102] smb3: add dynamic trace point for ioctls
Date: Thu, 23 May 2024 15:13:20 +0200
Message-ID: <20240523130344.540375760@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 073dd87c8e1ee55ca163956f0c71249dc28aac51 ]

It can be helpful in debugging to know which ioctls are called to better
correlate them with smb3 fsctls (and opens).  Add a dynamic trace point
to trace ioctls into cifs.ko

Here is sample output:

            TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
               | |         |   |||||     |         |
 new-inotify-ioc-90418   [001] ..... 142157.397024: smb3_ioctl: xid=18 fid=0x0 ioctl cmd=0xc009cf0b
 new-inotify-ioc-90457   [007] ..... 142217.943569: smb3_ioctl: xid=22 fid=0x389bf5b6 ioctl cmd=0xc009cf0b

Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/ioctl.c |  5 +++++
 fs/smb/client/trace.h | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 682eabdd1d6cc..855ac5a62edfa 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -349,6 +349,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	xid = get_xid();
 
 	cifs_dbg(FYI, "cifs ioctl 0x%x\n", command);
+	if (pSMBFile == NULL)
+		trace_smb3_ioctl(xid, 0, command);
+	else
+		trace_smb3_ioctl(xid, pSMBFile->fid.persistent_fid, command);
+
 	switch (command) {
 		case FS_IOC_GETFLAGS:
 			if (pSMBFile == NULL)
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index ce90ae0d77f84..f9c1fd32d0b8c 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -1032,6 +1032,38 @@ DEFINE_EVENT(smb3_ses_class, smb3_##name,  \
 
 DEFINE_SMB3_SES_EVENT(ses_not_found);
 
+DECLARE_EVENT_CLASS(smb3_ioctl_class,
+	TP_PROTO(unsigned int xid,
+		__u64	fid,
+		unsigned int command),
+	TP_ARGS(xid, fid, command),
+	TP_STRUCT__entry(
+		__field(unsigned int, xid)
+		__field(__u64, fid)
+		__field(unsigned int, command)
+	),
+	TP_fast_assign(
+		__entry->xid = xid;
+		__entry->fid = fid;
+		__entry->command = command;
+	),
+	TP_printk("xid=%u fid=0x%llx ioctl cmd=0x%x",
+		__entry->xid, __entry->fid, __entry->command)
+)
+
+#define DEFINE_SMB3_IOCTL_EVENT(name)        \
+DEFINE_EVENT(smb3_ioctl_class, smb3_##name,  \
+	TP_PROTO(unsigned int xid,	     \
+		__u64 fid,		     \
+		unsigned int command),	     \
+	TP_ARGS(xid, fid, command))
+
+DEFINE_SMB3_IOCTL_EVENT(ioctl);
+
+
+
+
+
 DECLARE_EVENT_CLASS(smb3_credit_class,
 	TP_PROTO(__u64	currmid,
 		__u64 conn_id,
-- 
2.43.0



