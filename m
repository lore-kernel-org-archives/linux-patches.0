Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041793;
	b=GkLD3VyvlkcBPZX1wo8Q+lRiJF563kOWDHbEvUc+69DFbjGboSsfCdm11da80oC6qUct
	 /9GXjCoAie8Q+d+SMXgTf6b4GmtWrqUslHRnaLOfkloUWwBkOL3Pq+cSYU5W/b3o0ZYEM
	 EoVeuhi41h0dtnf/QdvrsFG2r8CRY0nU+lC1g+eDAMAiaT1Xb8yB1OMfwdbuc9dZZLnxX
	 dURBo+5a+oSdRISyIOaXPWK0+IMK+I5NaOxbr/Fky8Gal3UgTyQTfvq6B0Ho551RRlLR2
	 dXgP97suBaNPHQ2EryH8gxh2bBzJ7r0tkS0riDzVejsgwVYLdPtfRar8iBufrvm13DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iV795qEfmCWHQzFevgnX2VB/l1f0hk+oIjmsH2Iw0ok=;
	b=nZ37V5kkOHNLkQzTVX733/41EI116S3oGW4znjbEaDc2a2/omduJK+I/v49ZJ5kdzYfH
	 qIJ0onkwm3K3B3DIrTbsvH7AgJ66JnnQI/QnayPB6s1Bb3yu4tgKjXMjEOYcnAurtGjgH
	 V8nB/QBZ85k5a8leYlbY9rsHxBXKZEpWS0nJvmsN4skEpJyAEMonrFNWlMr1WXgen4c6b
	 1880H81mGLSszc5SnxVo265neTmfnyB813aiyQW+yFsbF3ZUX8EaDJrzyOeg7M6oIGJYZ
	 WrtNEKmDmiXhBmleuZBY1X9eJm7iZq8NxosTLcick7ykKu9IKyAOkPqEtS7VhKewl5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJvVWrbk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE22606A325;
	Wed, 18 Nov 2026 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJvVWrbk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F201F000C4;
	Wed, 18 Nov 2026 22:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041793;
	bh=iV795qEfmCWHQzFevgnX2VB/l1f0hk+oIjmsH2Iw0ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJvVWrbkvNM7wAxicWkNe4tj9uyxzrSw7bD3U5iJaK3YQiMzOmf+uDVFYxjJeGPQm
	 7sIksGkIk70ZtyjwywusXEcVaXpBcdYigmLKz9EL0fbkIH+bu0/6nzi5SlVHzes3Rs
	 uwbK41cRDrhZsKdC7SSic4lLzWaik6XA/CNxAHjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2898/3318] scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
Date: Wed, 18 Nov 2026 15:58:40 +0100
Message-ID: <20261118150447.428959770@linuxfoundation.org>
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 4d7f9c3fdce773f6c69d17c1d4a05bd5e17f4b99 ]

The min_t(int, ...) clamp of the device-provided sense_data_len turns
negative for values >= 0x80000000 and is then used as the memcpy()
length, reading and writing out of bounds. Compare as u32
instead. Well-formed responses are unaffected.

Fixes: 366ca51f30de ("[SCSI] libsas: abstract STP task status into a function")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://patch.msgid.link/20261009033238.1076098-2-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index e9d291007817b..2080e5836179b 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -25,7 +25,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	case SAS_DATAPRES_SENSE_DATA:
 		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
-			min_t(int, SAS_STATUS_BUF_SIZE,
+			min_t(u32, SAS_STATUS_BUF_SIZE,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
-- 
2.53.0



