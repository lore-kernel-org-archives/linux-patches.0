Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A21E32B99B;
	Mon, 29 Dec 2025 16:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025614; cv=none; b=e7JNVYFhMC/7cJbKmLCKlr7v81KimWNUMr1gFMET/hlkBkEnJ0r9w1DKX+D9XO8mt546vIXwcflqoC0ldMc5knihfwkjPuOwWk4bv1gLFULyCZZKPWqvSyXecwmiZYUopepWDYiVVInP4X8f9PpKIICwBz3GhhfJ0DWaa2vU0Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025614; c=relaxed/simple;
	bh=dkT4aXprxnUQxYVus/k/J1aPoIF4HomPBYp/jMlPS9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJcd7HeKfiGTCt6UN9O9DfVxEYb4DW6ncZ9b+okTlOYcZMGDtIocGD0rxpc0YUSzdTYplXgVvlchE3UWyFnfKQN1ugvQQJbvn6sXhFeiwWfYxq8gtopsq7zp/YJywIxWCZFLIaARg2xq19BhdDFWrs7ldVc0pJR6E50+gPxyGdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHnzTN2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHnzTN2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0493C4CEF7;
	Mon, 29 Dec 2025 16:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025614;
	bh=dkT4aXprxnUQxYVus/k/J1aPoIF4HomPBYp/jMlPS9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHnzTN2WcUNk5iTrnryidKchAhB0M5OCJyzFYJBTSguXNkVQ14x1YFmWguyWf7C16
	 6sgSPBYHipNnGnG5ymIjQVQ3HV+plfakOf42/whf+JigrnN/yfuPNABTb4QxcE2dIT
	 ylKuEsEB/hl5Km3mtOYjgMpoW5dkuAWC50OqCVfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 242/430] perf: arm_cspmu: fix error handling in arm_cspmu_impl_unregister()
Date: Mon, 29 Dec 2025 17:10:44 +0100
Message-ID: <20251229160733.260830075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1365,8 +1365,10 @@ void arm_cspmu_impl_unregister(const str
 
 	/* Unbind the driver from all matching backend devices. */
 	while ((dev = driver_find_device(&arm_cspmu_driver.driver, NULL,
-			match, arm_cspmu_match_device)))
+			match, arm_cspmu_match_device))) {
 		device_release_driver(dev);
+		put_device(dev);
+	}
 
 	mutex_lock(&arm_cspmu_lock);
 


