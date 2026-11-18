Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039659;
	b=klfaznNW/Cp5rqTkPaJys0xgOhMnu5jiVWdmgMf+10/DapLfDFDbY6zkZm6p012P2HJl
	 Y3ksyvtgyOqDRxoy7hpG/md0xxzzACAt+a9oJHZ974jBI+2LWxhYI0jlJ2WLHKsWPcTL3
	 eh98UdQQ8G/09EKDyWZ05pYNoJwnxJdo6XqRK8iIOXt5q4RpruTXiJsas9j1miHPnd/pu
	 6zUmLUJKrJ2PQmGADrdovj9QoS/sTcKpPaK5Ms97m9qGz+MrJ5MRH105By8GujGrFCRIA
	 S/6mCoBWnADX40VuoOihbTZynHnTuDVZinPaXviPjB1eX67rvwMstLZBW90VRrEUtoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mJYlJw8Sie7C6T6KhwdIeMdpiOSx/RIZB+YuF8xECts=;
	b=Nf+ejz2EafjT7VIvM+zn/hy+fEg63Hpp+8iUT+4KyrY8q7/CEmfNprXTd91QCt4qvK7s
	 Of6Uz8yJZ61v6jNxtgCzVMYwpM6M/ov1yrE8GZhBpaxcmjtvggcxGWG2gZzCgEHB8tTXP
	 uqHhFiZC9YRquxKskpLQudgC9Bova0fKaoBmCluNTn/O1/huoLI+DzvUBVogOPKR1slVS
	 gHoeb/mR0z/B+UTngbZMrzXMKxfeg9aPk6f5Hud+ZnVNmm48A7J8YpOnMIeUx9Q11eKg7
	 UWfRClCcloVFKBMTBdUgp83Wn1SASvDtk/zVH17MXqe63zf1fO3wTz6176ltyQqEP3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9yw3Wsr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83638606A336;
	Wed, 18 Nov 2026 22:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9yw3Wsr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62CE1F000C6;
	Wed, 18 Nov 2026 22:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039659;
	bh=mJYlJw8Sie7C6T6KhwdIeMdpiOSx/RIZB+YuF8xECts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9yw3Wsrq+0xxMe6dLr4UqgYju1SF7xdLb/5CifJ1vfvb6G+cpzd5r4x7InL8kPSW
	 GeFksIrTfysBZtMAgj2khDVJ/dk0/Wyy9/kfEzI1Tjin1NfZkahsh9cgNWd+n3eTkm
	 kLukkXGlM3mXGJfxsti7SfJR0qThqmpkK0PCb1ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2142/3318] usb: image: microtek: stop SG processing after transfer errors
Date: Wed, 18 Nov 2026 15:46:04 +0100
Message-ID: <20261118150426.314128214@linuxfoundation.org>
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

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit d937ca39cc44a01ce64865dd25b1e205a05ae3a0 ]

When an SG URB completes with an error, mts_do_sg() calls
mts_transfer_cleanup(), which completes the SCSI command through
scsi_done(). However, the callback continues advancing the scatterlist
and may submit another URB for a command that has already been
completed.

Return immediately after the cleanup so that no further processing is
performed on the completed command.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20260723195654.152104-1-diegomancera.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/image/microtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 8c8fa71c69c41..4504c22f953cd 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -501,6 +501,7 @@ static void mts_do_sg (struct urb* transfer)
 	if (unlikely(status)) {
                 set_host_byte(context->srb, (status == -ENOENT ? DID_ABORT : DID_ERROR));
 		mts_transfer_cleanup(transfer);
+		return;
         }
 
 	context->curr_sg = sg_next(context->curr_sg);
-- 
2.53.0



