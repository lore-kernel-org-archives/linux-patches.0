Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5A4215779;
	Wed, 19 Mar 2025 14:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395083; cv=none; b=QShN0+46BAT++L+rtCyNLYAzWGcKR5okRIuhvhd+ebZnalxeubCRn6knuFyRwl68IKfSIC5mnUH2hCMMj/aNGE8DwMC34qCqIQZlTWE/kPgpNiqVilnpwGofK3ilbcQxVE5nYf62E//gH0CHR33ZOXg13X27liAp1iZTKzpV0uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395083; c=relaxed/simple;
	bh=pYbYJ2yPh1Te/Xel0kqyijQ9pvWSfsl4eqFynkZZqcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWk5g1dxKx4NEgrBf2ypsoh8NBQqI5s1u+y3zzxMziNv3twWkaCmxgxK1zfSPWq8KONzTqlJ5TCXVeqplWmrCkwwV5XptKXhwia4E2O5vOuInm81GPEg9qexptkKhINGYJj995UsgK0+QrTuDXI7fo2wqmGJeERCVQTB2faZ8ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u5ZN/FWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u5ZN/FWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A0AC4CEE4;
	Wed, 19 Mar 2025 14:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395083;
	bh=pYbYJ2yPh1Te/Xel0kqyijQ9pvWSfsl4eqFynkZZqcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5ZN/FWCw+u7+MpupWodh2k4PzVv2ah+sHKP3RB2SwxU4f/6upEO1U5ut31SVjRm0
	 XRLzDWVqZ4+wymbyVzqYeGRP0lI0nWyE4pYcEmzxJmOtnXq9FDY2p8jFFFY6pwh7Rk
	 dalx4pp35CFJwCLoarzbwWsL4mn/sxUCtkkUI9L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/231] cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes
Date: Wed, 19 Mar 2025 07:30:17 -0700
Message-ID: <20250319143029.904325309@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b587fd128660d48cd2122f870f720ff8e2b4abb3 ]

If the reparse point was not handled (indicated by the -EOPNOTSUPP from
ops->parse_reparse_point() call) but reparse tag is of type name surrogate
directory type, then treat is as a new mount point.

Name surrogate reparse point represents another named entity in the system.

>From SMB client point of view, this another entity is resolved on the SMB
server, and server serves its content automatically. Therefore from Linux
client point of view, this name surrogate reparse point of directory type
crosses mount point.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c    | 13 +++++++++++++
 fs/smb/common/smbfsctl.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index a3f0835e12be3..97151715d1a41 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1193,6 +1193,19 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			rc = server->ops->parse_reparse_point(cifs_sb,
 							      full_path,
 							      iov, data);
+			/*
+			 * If the reparse point was not handled but it is the
+			 * name surrogate which points to directory, then treat
+			 * is as a new mount point. Name surrogate reparse point
+			 * represents another named entity in the system.
+			 */
+			if (rc == -EOPNOTSUPP &&
+			    IS_REPARSE_TAG_NAME_SURROGATE(data->reparse.tag) &&
+			    (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY)) {
+				rc = 0;
+				cifs_create_junction_fattr(fattr, sb);
+				goto out;
+			}
 		}
 		break;
 	}
diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index 4b379e84c46b9..3253a18ecb5cb 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -159,6 +159,9 @@
 #define IO_REPARSE_TAG_LX_CHR	     0x80000025
 #define IO_REPARSE_TAG_LX_BLK	     0x80000026
 
+/* If Name Surrogate Bit is set, the file or directory represents another named entity in the system. */
+#define IS_REPARSE_TAG_NAME_SURROGATE(tag) (!!((tag) & 0x20000000))
+
 /* fsctl flags */
 /* If Flags is set to this value, the request is an FSCTL not ioctl request */
 #define SMB2_0_IOCTL_IS_FSCTL		0x00000001
-- 
2.39.5



