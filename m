Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705087;
	b=dZe9K6vWVABLERKlN8dugt6YirvfrPLJymNo2YasAMFY6wUDx2cE9AedyPy5eM/flHgy
	 QUDfthYnNdKyyCLDSrbI+uXbhFCr42Y4BGDH3KoCOkj4TqoNuKYW5Jb4ncXqa+S3sp8WN
	 JtmcnPlUa5mATlhoDZdRYy74ORIRl7u0S0+m27AFwiENO1RIBtrUlCulsDdVK4I0cN37b
	 KvidxgLI8vOMtrRpH0R/3pdD2MMFsVMU8Q1mr+BFy4waAXMT1Vpssk+VSFrEe9OVh2sBw
	 ulaS2HOoXpPGC8uxCz5bYPOu0Xhn6Kx9ZhawhxcixXBiXeo0oIVAZmpfMAJQY+Y0yPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705087;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CuqbdP9rVU0cJHsCUPt98ka115TR3Wq/4SQYkbbmmoE=;
	b=hArdRSW/4ldxOoKL3GmhaPUIIoo6VvlWV/REE8lzK9rmznXduIAr4QucncRLDSw2CZ4X
	 vDpwsoRDZtigRy4NBBkaOWuJUdIXCkyFU7PstC1gyo0T90H0w+hEfJgMkn00Tv00dhQrt
	 KoKcXTk19FJvJeU+OD6mMwkoNtmibeMUSk4HJzibWksBBYg3i95Qdl2iVNyZCaupMdSUB
	 mFwGB+D4cgV9a7COcIU6lm38BpczSnH1YX6vl3Lid8NiW0FEovMrpg9xckwseOFxPBTaq
	 zw7+MoXH8cTQdMaBDkXMzwukmwAVIsUFFHjY5UkQNxJex0qNND7qTfr/+ZAW/PTashQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFGob7dN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA77606A326;
	Thu, 26 Nov 2026 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFGob7dN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003661F000C6;
	Thu, 26 Nov 2026 14:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705086;
	bh=CuqbdP9rVU0cJHsCUPt98ka115TR3Wq/4SQYkbbmmoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFGob7dNkYMTQS7hNQR5U1ypc3HFJYfhDENYCdJpOCarq7Uko8HG5DRDCHuMm4e0G
	 MTaGh81GtLSXp9AH5ObriCaFNZ+glzC3CQ52BUyjGADwburYiCAUxHOot8U5FHIh9d
	 Q3JOgBJ4ooNdKkgdWPelP0li4GyxDIDfHJGpmmi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/319] ptp: unwind partially completed virtual clock creation
Date: Thu, 26 Nov 2026 15:36:41 +0100
Message-ID: <20261126144007.486988461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 3dea778260e3dddf30651a6913d87a42861346a2 ]

n_vclocks_store() publishes the new clock count only after every child
has been registered. If a later registration fails, it returns without
unregistering the children already created by that request. Those clocks
are left out of n_vclocks, and a subsequent request can overwrite their
index entries without removing them.

Unregister the newly created children in reverse order and clear their
index entries on failure. Leave the previously installed clocks and
their count unchanged. The n_vclocks mutex serializes this rollback with
other sysfs changes, and parent removal drains the store before walking
the children.

This was found by code inspection while adding initial PHC sample error
handling to virtual clock registration.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-2-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 88814e7d19785..2bde9f516af57 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -212,7 +212,7 @@ static ssize_t n_vclocks_store(struct device *dev,
 		for (i = 0; i < num - ptp->n_vclocks; i++) {
 			vclock = ptp_vclock_register(ptp);
 			if (!vclock)
-				goto out;
+				goto err_register;
 
 			*(ptp->vclock_index + ptp->n_vclocks + i) =
 				vclock->clock->index;
@@ -241,6 +241,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 	mutex_unlock(&ptp->n_vclocks_mux);
 
 	return count;
+err_register:
+	num = i;
+	if (num)
+		device_for_each_child_reverse(dev, &num, unregister_vclock);
+	for (num = 0; num < i; num++)
+		ptp->vclock_index[ptp->n_vclocks + num] = -1;
 out:
 	mutex_unlock(&ptp->n_vclocks_mux);
 	return err;
-- 
2.53.0



