Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B627D414;
	Mon,  8 Apr 2024 13:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583466; cv=none; b=qiDBlmkl+B2l3IzPLvrgL1F8pG4J79ywfUuA44pJVCvMJf3iKW9U3srm5YfUCrChUjRkSnExPkrvX5K1ilAuSaSp6V710SIsLSHEZt8Pbhnr8vKxExixsDfkXZJw2yOHFOvPMPCT8laAdZ190HT1EepHzWs7h+AeW6ZCgkwKbOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583466; c=relaxed/simple;
	bh=8RY95xkioBEGGIT2AIGytAx5r4p9vQpgz99rP+kbMag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YP4Zhq5O8aXv3nlRISCYoqlmPg5GrGx4+/ZULrVYt0PHShJNfSshXOg6KQl1s9eHeWBoP5QjVF26zmh/on5HlXo3ojpBF9qxwuouqn0YpVVX1D82NwTKpI+B8EF9e3GW22XBR3prvekmtOvVY9MiQoMiEj2kvPstPGD7yghZMJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUTITc0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUTITc0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D569C433F1;
	Mon,  8 Apr 2024 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583466;
	bh=8RY95xkioBEGGIT2AIGytAx5r4p9vQpgz99rP+kbMag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUTITc0pLtTfpXP7NUs5KIbmuVTW3wzb1eUXBpdJWAGwyvCZDTfQlYTKJTfad1CH2
	 ZyQAny7OvhPccdwy80egDK6P60FhqVOPR4iavy0jp2EdpQN+tmYNgUovp7tBqJfD87
	 Wv8NBPEEvkleCZlaqMT7xDwmCW6SZip13+aY2lsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 182/273] thermal: gov_power_allocator: Allow binding without cooling devices
Date: Mon,  8 Apr 2024 14:57:37 +0200
Message-ID: <20240408125314.939341866@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit 1057c4c36ef8b236a2e28edef301da0801338c5f ]

IPA was recently refactored to split out memory allocation into a
separate funciton. That funciton was made to return -EINVAL if there is
zero power_actors and thus no memory to allocate. This causes IPA to
fail probing when the thermal zone has no attached cooling devices.

Since cooling devices can attach after the thermal zone is created and
the governer is attached to it, failing probe due to the lack of cooling
devices is incorrect.

Change the allocate_actors_buffer() to return success when there is no
cooling devices present.

Fixes: 912e97c67cc3 ("thermal: gov_power_allocator: Move memory allocation out of throttle()")
Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_power_allocator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 81e061f183ad1..207a6a3936b54 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -606,7 +606,7 @@ static int allocate_actors_buffer(struct power_allocator_params *params,
 
 	/* There might be no cooling devices yet. */
 	if (!num_actors) {
-		ret = -EINVAL;
+		ret = 0;
 		goto clean_state;
 	}
 
-- 
2.43.0



