Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054801;
	b=5TKfTzBs9EjLmDcDfzOCK0toy/543+rQK3N4EOwudsqlQ9Y5oakvzXAgxLv6XmMw4tR8
	 Uegda7uh7iit/VhZqv8M0veLc3OLBU49HbdY9M+eFA15Y8rMOjL7LXHjycB4Nr/C7ahn7
	 jL8QEM/wAqvQaHqATRMsityEvp7g+oNDQesWfVTgnKdUbbI6jx11QZ7QhX3s4S3h7bc0V
	 BJw7XHyPgxZktv08i9w815k0Wi/d1rMeaS2y8CyjGRKZ63B31Ap0cbO2CyYF8YMUxJFrm
	 wPmMAt0g8KHUBC//HEPJjwNhGibTrxNfw2Z+g9cyccRTg3zv42XbiLgkpQTY/vbuYHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gMqybR0tFCDOdvJJJPPbHJjXzW2jA39zH1bBx1WvBm0=;
	b=DZWP8M2iDkq9NyX1p5LqFyn/i14UGNUqF59I4hNx81/90173NqiMi9btz2rbR23FgBh/
	 lAquHSh/xiYQL/y0+YCBiKcsFvdvkrePJLkQJxOFxidiO3h1SSpQXlOHPZA4fo5WH9J8I
	 GkzE0JDoS47EwwcvhUt0osbbO+Y6dBSDtfThnMqYWv+fUrkvAlBJ7ze/EAdcms4iCUFkm
	 SvI5T6zzLLko+sIqgoqWbHRHGbh7baxaFdjReqq+5ukM44ij4jUOrV+nhQzf51u7O1V64
	 KrFUD4dQkADBO7cjiC4iUgGinF9PJFdrghbban9rchi5L0grPqWM8aPCKIVEDFniD6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D62vcl5C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920DF606A320;
	Thu, 19 Nov 2026 02:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D62vcl5C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91AB1F000C4;
	Thu, 19 Nov 2026 02:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054801;
	bh=gMqybR0tFCDOdvJJJPPbHJjXzW2jA39zH1bBx1WvBm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D62vcl5CpytCdNuFttdts4JXZ3eDAdHxiaCVWgu1UKYySZ/pJdHvCHTg5n65AptPw
	 8M4dJ0rrfg+LdOQsari9zaT78yaATUhkdOZcMehZGjxKr6v/VFiZURn2Lzh6t0B+Th
	 7VKW2jxi+UZAZP9WLmUHSH1h0+wX2aGw+RGqXmGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	Danila Chernetsov <listdansp@mail.ru>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1377/2214] dlm: validate lock modes in recovery messages
Date: Wed, 18 Nov 2026 15:50:53 +0100
Message-ID: <20261118150106.476790550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 7bf1aca6d626944091a5cb218b4e487547edff0a ]

The DLM recovery path restores lock state from rcom_lock messages
received from remote nodes. The lock modes in these messages are
copied directly into the local lkb state without validating that they
are within the valid DLM lock mode range.

The rest of the DLM code assumes that lkb_rqmode and lkb_grmode
contain valid lock modes. In particular, LVB callback handling in
dlm_may_skip_callback() uses lock modes as indexes into the
dlm_lvb_operations array:

    dlm_lvb_operations[prev_mode + 1][mode + 1]

An invalid lock mode received during recovery could therefore result in
an out-of-bounds read during subsequent LVB callback processing.

Validate rl_rqmode and rl_grmode before storing them into the local LKB
state. This preserves the lock mode invariant required by the rest of
the DLM code.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e7fd41792fc0 ("[DLM] The core of the DLM for GFS2/CLVM")
Acked-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 0bf22cc598122..7b9b4c61e8955 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -5596,6 +5596,10 @@ static int receive_rcom_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 {
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
 
+	if (rl->rl_rqmode < DLM_LOCK_IV || rl->rl_rqmode > DLM_LOCK_EX ||
+	    rl->rl_grmode < DLM_LOCK_IV || rl->rl_grmode > DLM_LOCK_EX)
+		return -EINVAL;
+
 	lkb->lkb_nodeid = le32_to_cpu(rc->rc_header.h_nodeid);
 	lkb->lkb_ownpid = le32_to_cpu(rl->rl_ownpid);
 	lkb->lkb_remid = le32_to_cpu(rl->rl_lkid);
-- 
2.53.0



