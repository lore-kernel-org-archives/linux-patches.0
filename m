Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D003172798;
	Wed,  3 Jul 2024 10:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003367; cv=none; b=mmhUeA1B0EYn2UxinLu2DniCMpCNEKCScVDkfmCmf+4S2vCgk5QEMHIQCe1fGwCW0sNBW7yO1OVmInzVkgdbN058QbISwVysgxjQqyhHejzpv8GGp2WXDi6ZRDVuZ8tAA7HSNLSx4lKKyvW5og/hywK513S3Th5KPbfhW+UQTm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003367; c=relaxed/simple;
	bh=wKRAB4svr5YmmQSx81gGIABQ0rMiYnADKqh90TTPwlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHR0RBOmXUuuzZF8bBKqVH/jJyNvq0No/jTC/5S9HGnmhYDpppD3zrbRJ4z1Paf6QywuLRsq5gXDkDpNHrQIsn5vHHkII0nhWS5f4HB+CUTz+D7AQmvIQTst27VIDUFFrY9NXRy4pmr0frC1Wi0noanzR3q6i3FbhEs07pJHgaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dboH5ffg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dboH5ffg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3ED0C2BD10;
	Wed,  3 Jul 2024 10:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003367;
	bh=wKRAB4svr5YmmQSx81gGIABQ0rMiYnADKqh90TTPwlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dboH5ffgEqe0JgpRiJslVpUU7zEq4mALt97/b9Uo8AP7KwlVrlcMBMEFQH1y3aCcz
	 Co0v7rZhLZzs74J7/jiVV9SOS11zki3Nn7PypDGA/PIyP0ZB6tpoff5aZM2udzdNxd
	 zX7ox+CmV1uyhAw2crGuKHIxXQgx6zPG08dAJck0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/139] ptp: Fix error message on failed pin verification
Date: Wed,  3 Jul 2024 12:38:25 +0200
Message-ID: <20240703102830.751911643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 323a359f9b077f382f4483023d096a4d316fd135 ]

On failed verification of PTP clock pin, error message prints channel
number instead of pin index after "pin", which is incorrect.

Fix error message by adding channel number to the message and printing
pin number instead of channel number.

Fixes: 6092315dfdec ("ptp: introduce programmable pins.")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Link: https://lore.kernel.org/r/20240604120555.16643-1-karol.kolacinski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_chardev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index 8ff2dd5c52e64..f66ce68f42379 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -97,7 +97,8 @@ int ptp_set_pinfunc(struct ptp_clock *ptp, unsigned int pin,
 	}
 
 	if (info->verify(info, pin, func, chan)) {
-		pr_err("driver cannot use function %u on pin %u\n", func, chan);
+		pr_err("driver cannot use function %u and channel %u on pin %u\n",
+		       func, chan, pin);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.43.0



