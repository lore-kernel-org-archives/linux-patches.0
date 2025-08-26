Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CAE1F4CA9;
	Tue, 26 Aug 2025 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215551; cv=none; b=KCbBAEDAQVRBRgpvwsOREgoDavs6KK5BzJUVX4Uga0k4OugHpErJUEB4vy8kHpzxfglfT6WH+hXxZT4sFFSnem/wHJMEqhlJjQAAKTMNh5zy0HeuaTS3Kn8dPCrcSHkkNxpHnrLzZzcYHAfl9he+HkKsl83AxMCc2jSR5WgW5Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215551; c=relaxed/simple;
	bh=Paxnv7urBg5z0omzGOFdWitgaCWH8KP3AZJhZKZz60U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOUKvD4gEsH89ycXMA1jrBSF3zik8w6X6Fp+wy4CHd/CRa5v8h8Cq783r7VOYsgW1avXrNVNEgsFdRn9yA5eq+VAMr1WDvAqD9/AOino5KZYA7EWADr7EXE8J7ifMjbWEO/BS03vHpNl8DJ+bYRSQAxB8iLM6tLsU/ORbeXL7kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8fOxl1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8fOxl1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BE3C4CEF1;
	Tue, 26 Aug 2025 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215551;
	bh=Paxnv7urBg5z0omzGOFdWitgaCWH8KP3AZJhZKZz60U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8fOxl1y7j4EmUD6IpPoSl6L07MjFWXdLp4mzZxCuSg1J3oQN1VR6q2Jwxy1oWV0Z
	 cULEv1IyLjPBYED3g7bqeqoH12dyLQ5DvXRJ7c8tGHmA0jYeifQ1pYgc/p5fYn4u1x
	 0rbjLGs5lfS9Wivo/Y8B/ufduUBpysoXKqGxJyLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Carminati <acarmina@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/644] regulator: core: fix NULL dereference on unbind due to stale coupling data
Date: Tue, 26 Aug 2025 13:02:48 +0200
Message-ID: <20250826110948.405971033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 18f13b9601b5b..ed5d58baa1f75 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -5359,6 +5359,7 @@ static void regulator_remove_coupling(struct regulator_dev *rdev)
 				 ERR_PTR(err));
 	}
 
+	rdev->coupling_desc.n_coupled = 0;
 	kfree(rdev->coupling_desc.coupled_rdevs);
 	rdev->coupling_desc.coupled_rdevs = NULL;
 }
-- 
2.39.5



