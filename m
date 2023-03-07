Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B24EBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD045C433EF;
	Tue,  7 Mar 2023 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211175;
	bh=WxYwa2Cc30nYji1sh4OZhymFEFDeZ8K9EQ836M/pyes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tt6OjYZ770zeI5iGBNoj2H6JwhTCGxUnPb8TsSmqaMU3KyrAPMU0OgN0U1BwcnhhM
	 v1LxUIvAKjMSb+qdBwaNF3n/3a90+NTN/KQGAU5OfrmVTU7GFujyK+OxNa74druUyl
	 Yf2nIT/eVumqwKDMf9EjdYG53dTIHdC2JA10RLcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Bharath SM <bharathsm@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 0777/1001] cifs: Check the lease context if we actually got a lease
Date: Tue,  7 Mar 2023 17:59:09 +0100
Message-Id: <20230307170055.472481554@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit 66d45ca1350a3bb8d5f4db8879ccad3ed492337a upstream.

Some servers may return that we got a lease in rsp->OplockLevel
but then in the lease context contradict this and say we got no lease
at all.  Thus we need to check the context if we have a lease.
Additionally, If we do not get a lease we need to make sure we close
the handle before we return an error to the caller.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cached_dir.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -221,8 +221,7 @@ int open_cached_dir(unsigned int xid, st
 		}
 		goto oshr_free;
 	}
-
-	atomic_inc(&tcon->num_remote_opens);
+	cfid->is_open = true;
 
 	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
@@ -239,7 +238,8 @@ int open_cached_dir(unsigned int xid, st
 			    &oparms.fid->epoch,
 			    oparms.fid->lease_key, &oplock,
 			    NULL, NULL);
-
+	if (!(oplock & SMB2_LEASE_READ_CACHING_HE))
+		goto oshr_free;
 	qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
 	if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
 		goto oshr_free;
@@ -262,7 +262,6 @@ int open_cached_dir(unsigned int xid, st
 	cfid->dentry = dentry;
 	cfid->tcon = tcon;
 	cfid->time = jiffies;
-	cfid->is_open = true;
 	cfid->has_lease = true;
 
 oshr_free:
@@ -282,12 +281,17 @@ oshr_free:
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 	if (rc) {
+		if (cfid->is_open)
+			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
+				   cfid->fid.volatile_fid);
 		free_cached_dir(cfid);
 		cfid = NULL;
 	}
 
-	if (rc == 0)
+	if (rc == 0) {
 		*ret_cfid = cfid;
+		atomic_inc(&tcon->num_remote_opens);
+	}
 
 	return rc;
 }


