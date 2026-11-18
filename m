Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037165;
	b=pr41KLUU8uD/F5JkZm3kdmwebvlA0jHZQ2WfZ/Ieh97BPHksSNFy3PEov+BMVGn35MvO
	 4fu2/EaFlkb4jPkVLzva56kdKTsBDwvlXX3Tg8X+9QMB9CsHiwfq9k/lPLTp9+A3FumOa
	 mXDZgOpF5pRs8n7/MJSnrB++SwAjG8IvASMYWO8vaf9qOvm057/KHheZ4ZrY44NlpixAZ
	 JGkWdAmxMTPIUXFdWNBV2Mfcc6e12Uy7SfpZR1j/XodNF5CKGCLQ1I0JnUtdO2V6X/zKF
	 JNwA5XIs6ae+cLFCVkM0zyypZpLO/SKI3E/YWq8Tq19MuQy+Hz1gR73HWpYjiXhI27w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G0iKvjepNPbvt+rFxUBa5Vr2g445F7HaBnwhrLs1sgo=;
	b=TrwSD2gslDOuaIwehex9bL0ZyEBskpIhqz62QD5t+OHc97bN2wqaJ3EPsPUmKeuis0RY
	 1ObL21aYk5fItI55GhxTdNPf4fTtizI22SAD2OPyPcotVxmg7F8i4gDkLhYPzpwGNGPdo
	 Ots9S76uI+rHndJqwBNt842W6QdpXCHv/SwMdbGmPlUH1G0noSfByIaqqd8J6WXzXJ6TY
	 zVymyh8nscpaZ15u29iYiLQR4EnaFFhfuAyh0k+Ie+gZLd2B7KqoctZxPAmFWNNmMekbe
	 M3fMHiXIDru9h0g6pYZuJcqaPerYPAGdQKYZrPV1V0eEnmfogc3OnK7j22Hgz3Op1GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="D9Moh0i/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7065606A334;
	Wed, 18 Nov 2026 21:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9Moh0i/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF761F000C4;
	Wed, 18 Nov 2026 21:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037165;
	bh=G0iKvjepNPbvt+rFxUBa5Vr2g445F7HaBnwhrLs1sgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9Moh0i/2hKF8vu03CjHSKMuXn64uW80eMHTLeYqxg9P+BLtNoO05ZwF69wo3KJJ+
	 dFgRdB5vk5AhJzXSruqMBfiawy3cM0rQY4Rhy+JDfiGMeJ4zUhu4+BqhzbgbXTuGga
	 rKTi7kaC4VD1XLcmAh1h4EhdpJlneZ965AfSqwmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1317/3318] smb: client: bound POSIX lock data area by response length
Date: Wed, 18 Nov 2026 15:32:19 +0100
Message-ID: <20261118150359.822322905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>

[ Upstream commit 8fc9af68c57156ff64769f30e831553cd03b3000 ]

CIFSSMBPosixLock() receives a TRANS2 response whose server-provided
DataOffset and DataCount are not required by validate_t2() to describe an
interval inside the response. A server can therefore make the client read a
cifs_posix_lock beyond the response buffer and return those kernel bytes
through F_GETLK.

Use smbCalcSize() to obtain the full response length after any multipart
TRANS2 reassembly, then reject data areas that extend past it before
dereferencing them.

Fixes: fc94cdb94462 ("[CIFS] Fix new POSIX Locking for setting lock_type correctly on unlock")
Reported-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Cc: stable@vger.kernel.org
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Subtracted 4 from smbCalcSize() and replaced smb_EIO2() tracing with plain -EIO. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index e38d1489bb135..8406291dfcbf5 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2056,6 +2056,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
+		unsigned int rsp_len;
 		__u16 data_offset;
 		__u16 data_count;
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -2066,10 +2067,16 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 		data_count  = le16_to_cpu(pSMBr->t2.DataCount);
+		rsp_len = smbCalcSize(&pSMBr->hdr) - 4;
 		if (data_count < sizeof(struct cifs_posix_lock)) {
 			rc = -EIO;
 			goto plk_err_exit;
 		}
+		if (data_offset > rsp_len ||
+		    data_count > rsp_len - data_offset) {
+			rc = -EIO;
+			goto plk_err_exit;
+		}
 		parm_data = (struct cifs_posix_lock *)
 			((char *)&pSMBr->hdr.Protocol + data_offset);
 		if (parm_data->lock_type == cpu_to_le16(CIFS_UNLCK))
-- 
2.53.0



