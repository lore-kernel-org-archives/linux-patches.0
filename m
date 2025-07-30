Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B1C293462;
	Wed, 30 Jul 2025 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868611; cv=none; b=BEXWDoQSm43m7A3AKtlIcOtW/c7dZNpK9P/JYLq/bIsGcMr0FXyfBYcR0iDusNz5pyjajERJ+xNl10czqQ5w5/XU2JLX5meqbxcgVNtHyI3lT/xqi8PJLz0qX1vDbZ3FezXVg5vyshe4HWDy4ABBSsOAiLeFbK/y2jUIoWAo5aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868611; c=relaxed/simple;
	bh=crQCQDPiL/TG2vwVn4rNCAeC0XvA3KLHj3CfOVt7P5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bopTMA1xJgutC3vU9UNwsgHq9ciPU4EkHzJIVoCXHduvjMZNpDXkuHD9qOGxwT02+Hu7q/v8q+w/nckvmfe1f6XqY68LlvcFOdftboXgXOZvsyp6qJnN8bVnRUaS7lEH/+NWrLNB+EwpYyCMVeFkrfCJYkP7qn0bYyJkfR3e8nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqwhT0Ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqwhT0Ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88071C4CEE7;
	Wed, 30 Jul 2025 09:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868611;
	bh=crQCQDPiL/TG2vwVn4rNCAeC0XvA3KLHj3CfOVt7P5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqwhT0Ee67NEX5GJrYyCwBOvURH7qGb2XYeGG14TRi1kzmQYeSgf5vMDX5/uZPW+S
	 Fcxzv8YnX7OFJB3H08AL62pjuykDD4v8tmcI0itTvyQAJoODcEFhTTq+/3QBcdW7i/
	 Fmhp4iLL9zwKdhiZP0GiMUpQuKKeT96D2OH0kQSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Carminati <acarmina@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/117] regulator: core: fix NULL dereference on unbind due to stale coupling data
Date: Wed, 30 Jul 2025 11:34:34 +0200
Message-ID: <20250730093233.803511735@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Carminati <acarmina@redhat.com>

[ Upstream commit ca46946a482238b0cdea459fb82fc837fb36260e ]

Failing to reset coupling_desc.n_coupled after freeing coupled_rdevs can
lead to NULL pointer dereference when regulators are accessed post-unbind.

This can happen during runtime PM or other regulator operations that rely
on coupling metadata.

For example, on ridesx4, unbinding the 'reg-dummy' platform device triggers
a panic in regulator_lock_recursive() due to stale coupling state.

Ensure n_coupled is set to 0 to prevent access to invalid pointers.

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
Link: https://patch.msgid.link/20250626083809.314842-1-acarmina@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 1f4698d724bb7..e7f2a8b659477 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5536,6 +5536,7 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 				 ERR_PTR(err));
 	}
 
+	rdev->coupling_desc.n_coupled = 0;
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	rdev->coupling_desc.coupled_rdevs = NULL;
 }
-- 
2.39.5



