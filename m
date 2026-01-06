Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F53354AEE;
	Tue,  6 Jan 2026 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720178; cv=none; b=ldDSi1ZZB92YFvE/CU5XFksEbwGu/23lb3VUbNzcvGHMByJdjKHCWJ1+4/P878P+gvbDBlqrXaUWpd77xQryXRoJk4Isrfi9ge4owzFDUum5BZcLCyzh+wU+h5a0O7tfVNsXcTP48LeOHY9EnDzv/tkabs5kqaMxXsZzFUIglEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720178; c=relaxed/simple;
	bh=VqvCLcn3LJeDLSmWqfw8/kniQb9wTvn+A3Zw7V/ucGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCXJhdTsps5hnusU41VPDwVllbhsSdfDdkzYD24NIqEq+b2wuWQdS9uwcsMzenxNBWZb5xO3iq5uhBW4S3TfyxYCfjFUtq9HeQHMqS0jJlhRCXGhlqyFfSXvFoHstXpV3+zzgNLwS8KdJtrc9b2+cLUeRkKPu3kppdaDWlg4014=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuFe+raC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuFe+raC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F76C116C6;
	Tue,  6 Jan 2026 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720178;
	bh=VqvCLcn3LJeDLSmWqfw8/kniQb9wTvn+A3Zw7V/ucGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuFe+raC9G+tqcC1/kWhEiFXbk3zETF4ISUKPlU+l88ETdWrrsHj3h26edpBWWz8L
	 EQQlwrcWwfFxHOD0VoQPdzN/XRLADVbY8B1R+4kaIPom5/hw31LiYmEZ4XqNKGuF9b
	 vlGcNikXdHy4yU4wRSQugGBomfUwpqo6Q7kCDUTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 157/567] perf: arm_cspmu: fix error handling in arm_cspmu_impl_unregister()
Date: Tue,  6 Jan 2026 17:58:59 +0100
Message-ID: <20260106170457.136929442@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 970e1e41805f0bd49dc234330a9390f4708d097d upstream.

driver_find_device() calls get_device() to increment the reference
count once a matching device is found. device_release_driver()
releases the driver, but it does not decrease the reference count that
was incremented by driver_find_device(). At the end of the loop, there
is no put_device() to balance the reference count. To avoid reference
count leakage, add put_device() to decrease the reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: bfc653aa89cb ("perf: arm_cspmu: Separate Arm and vendor module")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm_cspmu/arm_cspmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/perf/arm_cspmu/arm_cspmu.c
+++ b/drivers/perf/arm_cspmu/arm_cspmu.c
@@ -1412,8 +1412,10 @@ void arm_cspmu_impl_unregister(const str
 
 	/* Unbind the driver from all matching backend devices. */
 	while ((dev = driver_find_device(&arm_cspmu_driver.driver, NULL,
-			match, arm_cspmu_match_device)))
+			match, arm_cspmu_match_device))) {
 		device_release_driver(dev);
+		put_device(dev);
+	}
 
 	mutex_lock(&arm_cspmu_lock);
 


