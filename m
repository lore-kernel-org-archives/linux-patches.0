Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040029;
	b=nEG3yLYInmb8yFQlh5szCOaJtwI8Iq9ec0OajqKaLc+zlEyIx9DDAeDLdJOZsLv9Y/7H
	 1OyQIBCtkNGZVFFH07gKTPkUt+MZxw9VCkb+ytlXqpKhMTKPWBBkXdidC7QFEWdtyfv2H
	 vvLKnEiJMNNJF7b46kYra1CnDE8qmagtJ/Hvxxn8CqEnJcm2TYWcqEQyGH8cyf6JTuC4W
	 lAdStHMMmSjbBUiL8MCcWPhtzzTCymhBYi6Y+esIBlnb/GOsB3kcEdisn7zdOMkJmRPWO
	 t42N/JmffUkhxhOoApMJEerAV+WHMWw/aamBTyHc1fwrQUAMFfZ6dt7Jog6S4Y6ozPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R89xzS59cGHpEvL0gKWtWvBVGuo+2dzjNmKKXHsOxuE=;
	b=EpusmKoCFAq/TS7wvQbc3WDKNfxpxbJn3HfiiVP0zzzAsItqWSuKoaz7bd4DsZkEjGOY
	 hr5buI99OvBc+SrqyZZOD/lKB/i3OLjkyjSUNKP93ps173jKIO3nEeFDKUj7zrw6/RivR
	 sJTmc+TC+yih84bLRNtV1ojf/FFNb5W1XheRgbqfj/Xy8mpFhOWiwhL2lAGToUamF7Qet
	 iPvCfCT7C2AIMcX8YxOtktyltYljefnY7JKwQ9nAnSU9GN0cljqk7eF4f1akG1b7q08F4
	 GqGwXOBpxZi5wUMDbok/uIMVmBJE5jbXAne77Z6US6Y0Aql+9OydB2dxKyU4iWd3U1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoHabovJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D97B606A31C;
	Wed, 18 Nov 2026 22:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MoHabovJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6599E1F000C4;
	Wed, 18 Nov 2026 22:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040028;
	bh=R89xzS59cGHpEvL0gKWtWvBVGuo+2dzjNmKKXHsOxuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoHabovJ1NT+6laE1smArZtxFfmaSt8voVCG6G9xnk1QE3x2OB39yw9YfTHQlT0B8
	 DsM86KTAKw2IK+9bYR9RJpgDu3b3tTjN49xwFrusWsorL7b64BelGg8/hbQUz8RaJz
	 ZPSCxmmz7m/s4lsgkSifHV1QbQM1h4mBimqS1RUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2310/3318] swim: Dont disable drive after every sector
Date: Wed, 18 Nov 2026 15:48:52 +0100
Message-ID: <20261118150430.995201035@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 05a7c4b197279cfb3ec3df26146ce085a2438aec ]

This fixes multi-sector reads on a Sony drive. The Mitsubishi drive
doesn't seem to care either way.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/fc511e72753ae18b6f021701aa00d480335b0caf.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 061285df459b4..741e6086da851 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -473,8 +473,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	short i;
 
 	swim_track(fs, track);
-
-	swim_write(base, mode1, MOTON);
 	swim_head(base, side);
 	swim_write(base, mode0, side);
 
@@ -490,8 +488,6 @@ static inline int swim_read_sector(struct floppy_state *fs,
 	}
 	local_irq_restore(flags);
 
-	swim_write(base, mode0, MOTON);
-
 	if ((header.side != side)  || (header.track != track) ||
 	     (header.sector != sector))
 		return 0;
-- 
2.53.0



