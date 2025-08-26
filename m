Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA8C1662E7;
	Tue, 26 Aug 2025 14:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217206; cv=none; b=Fcd+Y8CIjDajIx+plcD2y80OZexGF3xPuZNnn25ImILr2NaJjCgrnEee0FmnUkR1wnJxAN/UuNuuXaq91BXhbxDsDaVaAykQTyu7A+2QsW2ZWZJn3ThQp068SEg8fZw3NxX9shj6PssBoB/pQK0TtYJv+Pp2P0XiF7832tP2Vhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217206; c=relaxed/simple;
	bh=7CSEAptk8iclMR/0E+CBTkRU+eeME8YZdBlgXlxVZgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAbIZB+rwArCeocTOozuWn77i7p2AMEkgVuXqarDiXgH1jGjj8j30N9tb05zn/g++FCOTDcrr9fuwr5AnFu1auKSjx66KZBPio0Bv2AWzFYRpnTLjhKOlveDytyEL6ACowDmJdggufD/NnYlXxxwUhv426szv6i/GbKedUHYhjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ij6F2ABl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ij6F2ABl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C09C4CEF1;
	Tue, 26 Aug 2025 14:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217205;
	bh=7CSEAptk8iclMR/0E+CBTkRU+eeME8YZdBlgXlxVZgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ij6F2ABlLUOCizi//rCmhVR4ad1tzRf6LUli4WuaCbyNfhoWxjtHShRlH8bmyVue9
	 e9Xut401S6px9Ofu96GgVYj0ILdO1QFvND5y56KeEL8MhTIpQhLJb7ft5eBVrQkNM/
	 cLu0Tq5uWIaE5HNi/knXbQ5kyQtIONXXQowCtq1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Carminati <acarmina@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/523] regulator: core: fix NULL dereference on unbind due to stale coupling data
Date: Tue, 26 Aug 2025 13:04:25 +0200
Message-ID: <20250826110925.949446829@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a0cc907a76c18..b2d866d606512 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5198,6 +5198,7 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 				 ERR_PTR(err));
 	}
 
+	rdev->coupling_desc.n_coupled = 0;
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	rdev->coupling_desc.coupled_rdevs = NULL;
 }
-- 
2.39.5



