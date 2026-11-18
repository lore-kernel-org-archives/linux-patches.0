Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046265;
	b=VG4M9vtThBqxlpiYrjahYc8kh80TQLqfsCqFGCTZ8U19TuUAg/wb7uxTB6i+1deq+Qz3
	 e0JG1unYiBFJclKWFEvttz81YY69dvtk5Fu7i+KbsjTpNNSXg4W/Cuabyb22QWtojwqH6
	 41MT/KS+zq1fMWV8jOcIgzcuaWKNuFUuGGlpNmZ9GqVLh/xl4ucGDDhZQMdwFuVszYPst
	 Aj8UtP9OZ4r+FQVIwGSSOoVOv/43OovLZLf2qNCGshvKm3op7SyoyuECadp0jTMj+8SJk
	 NvVGpl5t+YTvmisVEMjbajfOnGBkq+Xa4f3Aq/GqUWE2ngPzCDPVUx2UOq5cukXrMgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+wXkdTsD1YhflRa2eaD3PiIpyUBBUoyF+4ysUqu28SY=;
	b=ykE/4B+4AsFKnPjulHZMrxU1PR3TeO2irhWw6ohRrTCx9+giRo46DO04Dbz98H8ngYxM
	 9VuWd1p25sFPQ3+mjAjsLhztWo7uTIInM7tlQv3eQPta9FPE8BhgJKHvEhpRVe/USfkE2
	 bFQigq4Eynd0u0kPZyhzvmvfzqBOZjngvttPDtw7kEWf7bgin54QMBnbODB6cbbKIPBx9
	 p46PhWne569aZGdmb1cFgn0LeTj2r4W2ZntBDkKtKfRw5l58Q8WdEu9r4J1NQ2z4dsjtB
	 G2S7jak8eR1RkD048CJe3EGysejlosbJ0/TrlWRjBAAIhp9Sx4F2g8dNqnpGbeD/Gmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wx7EsqKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BAA606A325;
	Wed, 18 Nov 2026 23:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wx7EsqKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA941F000C4;
	Wed, 18 Nov 2026 23:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046265;
	bh=+wXkdTsD1YhflRa2eaD3PiIpyUBBUoyF+4ysUqu28SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wx7EsqKUJnUXfSm2fzmyRVUGDuK+rhvCV27s8YbhhJ902V7vzVMLJscIUqXS67SoE
	 CdmtAdrItqnfFLRiqU/oUwEroBKouKw3nrK5eSmNC8x7gpTMZHSDPSZ7f+0NolxVdH
	 FmDG8DE2nKuweV+7nJZRF644DXMjzacFo24X3DcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1220/2857] ksmbd: require DELETE access for delete-on-close opens
Date: Wed, 18 Nov 2026 15:37:34 +0100
Message-ID: <20261118150245.502730049@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 1dd91081ba3c692565f9c1f884149178d5a06d1e ]

smb2_open() accepts FILE_DELETE_ON_CLOSE on an existing file without
DELETE in DesiredAccess. When the request asks only for
FILE_READ_ATTRIBUTES or READ_CONTROL, it also skips inode_permission()
and the parent directory MAY_WRITE | MAY_EXEC check that delete-on-close
is meant to get. The file is then marked for deletion by a caller who
could not delete it.

The unlink happens later, in __ksmbd_inode_close(), when the last handle
on the inode is closed, and it runs with the credentials of that handle.
If the caller closes last, the unlink fails. If another user who can
write the parent directory, such as the file's owner, still has the file
open, the file is deleted when that user closes it. Until then new opens
of the file fail with STATUS_DELETE_PENDING. So a user with only search
permission on a directory can delete a file in it, or block opens of it,
while the owner has it open.

A MAXIMUM_ALLOWED open that also requests DELETE has the same problem.
The requested access is replaced with the maximal access, which does not
include DELETE when the caller cannot write the parent directory, and the
later permission checks are skipped as already done.

MS-FSA 2.1.5.1 requires an open with FILE_DELETE_ON_CLOSE and without
DELETE in DesiredAccess to fail with STATUS_INVALID_PARAMETER, and Samba
does the same. Add that check to the CreateOptions validation, using
the generic-mapped DesiredAccess so that GENERIC_ALL still qualifies.
This also refuses MAXIMUM_ALLOWED with FILE_DELETE_ON_CLOSE but no
explicit DELETE, as MS-FSA and Samba do. When MAXIMUM_ALLOWED is
requested with DELETE but the maximal access does not include DELETE,
fail with STATUS_ACCESS_DENIED. With DELETE requested, delete-on-close
opens go through the existing parent directory check.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 56c173bdd020a..069ecc1d90b52 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2925,6 +2925,14 @@ int smb2_open(struct ksmbd_work *work)
 				req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);
 			}
 		}
+
+		/* MS-FSA 2.1.5.1: delete-on-close requires DELETE access */
+		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE &&
+		    !(smb_map_generic_desired_access(req->DesiredAccess) &
+		      FILE_DELETE_LE)) {
+			rc = -EINVAL;
+			goto err_out2;
+		}
 	}
 
 	if (le32_to_cpu(req->CreateDisposition) >
@@ -3105,6 +3113,13 @@ int smb2_open(struct ksmbd_work *work)
 		maximal_access = daccess;
 	}
 
+	/* MAXIMUM_ALLOWED may not have granted the requested DELETE */
+	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE &&
+	    !(daccess & FILE_DELETE_LE)) {
+		rc = -EACCES;
+		goto err_out;
+	}
+
 	open_flags = smb2_create_open_flags(file_present, daccess,
 					    req->CreateDisposition,
 					    &may_flags,
-- 
2.53.0



