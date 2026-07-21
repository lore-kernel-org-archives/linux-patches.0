Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD3403AFB;
	Tue, 21 Jul 2026 17:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654938; cv=none; b=L//POjpc29eCneEuObPyWWee54Ea+7ZoHsZJq2SfxYHcOyPHqLe4u48jHRNWvtOE5ATOOJ+JW1VRBCqMKqGO1U61DkQhuObipmtew20y9WURhmJMyVL+nuPMSOu5wOIh5lbvwBFqoYtm4WYHJrNadG4OAdf3FWzbKNTveugJm6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654938; c=relaxed/simple;
	bh=bDKmzYUC65b8xGH2CdQi797jnLte//bY2zsfXIgcEbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNRz6npun8R2dh/qZSRgejbJr/40UkuWyOVZ7ETe2ELHzTMvmb6sbJblU/hN5zJmKT3/3poTuUhSTZthkUqgckNxM8eHBqEW821eM1angcFtmsfWc7sdBrdYcA8EpeJCj5zkOmgmdKm0nyUr037HXiJsCG4b5aFSR1S4SYDuGOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDZI3mJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDZI3mJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA071F000E9;
	Tue, 21 Jul 2026 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654936;
	bh=DKjJOTs47WtnoBBJ7bAkY8ED45Q8hdc5LgP1ilOFHTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDZI3mJq6R2p3JEt45vVq+LlZPLF2CQ2O4tnVKKKLRZPkkHG848/ShkLxfd/USjhe
	 Aa8Q3LpcnUXAAk7nsw4sXX3q+YKfYG258KiF7Bil5nS7/6KrvcPTcixH3r0WKO1nUP
	 lzeaY9vbGkuX1CC+wREvmb185mHBWotc6RIy0F+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1850/2077] dm-stats: fix dm_jiffies_to_msec64
Date: Tue, 21 Jul 2026 17:25:23 +0200
Message-ID: <20260721152636.371328783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 386df1a57b631c456d14f857cb0c0c2e11c16bef upstream.

There were wrong calculations in dm_jiffies_to_msec64 that produced
incorrect output when HZ was different from 1000. This commit fixes them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -842,10 +842,10 @@ static unsigned long long dm_jiffies_to_
 		result = jiffies_to_msecs(j & 0x3fffff);
 	if (j >= 1 << 22) {
 		mult = jiffies_to_msecs(1 << 22);
-		result += (unsigned long long)mult * (unsigned long long)jiffies_to_msecs((j >> 22) & 0x3fffff);
+		result += (unsigned long long)mult * ((j >> 22) & 0x3fffff);
 	}
 	if (j >= 1ULL << 44)
-		result += (unsigned long long)mult * (unsigned long long)mult * (unsigned long long)jiffies_to_msecs(j >> 44);
+		result += (unsigned long long)mult * (unsigned long long)(1 << 22) * (j >> 44);
 
 	return result;
 }


