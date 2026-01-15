Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE23F396B75;
	Thu, 15 Jan 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496000; cv=none; b=b1Pd0VRYoIZo/0ZkdX2LS2kLKfJMbLCPyqGVoJSz7NdbKTzpAq060WsHqqnvZbD1uZ4wcK/tzrc3YPM6ezs45AEv9nFibkl8nGh0GwTE5AJkssz9w3r17ZRe2Vx77NVvR9+9BkRfcAJwQKCLPt76nCQ0ugW4BO6YIgNJooWUH2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496000; c=relaxed/simple;
	bh=2Xl7rEhFSQGPW4ZzWVXxsEkhvIIuOpJOB0mWdGML64M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/3R0Zc5M8qxzcpzOMfI9jZyf7Lt9+/T0IwHHoX75T7RJvQ1EckCT67pIrUIxaUsfaW8Q6qrJe2WGBA8klpneERThTq0Bu3PIBZr/1niPgg8ePEywZt/N4/gisS7GBVbypbL2juaqV1F/Bnkud6y3G9cgSWNCnWPn8jaCdHIUN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+stWOij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+stWOij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A08AC116D0;
	Thu, 15 Jan 2026 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496000;
	bh=2Xl7rEhFSQGPW4ZzWVXxsEkhvIIuOpJOB0mWdGML64M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+stWOijlUD65UD4F8/U3/Rv2Fgci2hI0jQRHwMLEJ/7NGDl+BdZ/fH944dIdlrhD
	 f2e40TxdfIhvmNoxVOTV+3BsWs9Vkqx8/P1kD8BYgeW8VT68w03TZ9tRR1IzMGM+VY
	 Vi3zc0oqAVP6hvm7/ArrB6KuRr8HobNEl07x2O08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <mrout@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 035/181] PM: hibernate: Fix crash when freeing invalid crypto compressor
Date: Thu, 15 Jan 2026 17:46:12 +0100
Message-ID: <20260115164203.595145257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Malaya Kumar Rout <mrout@redhat.com>

commit 7966cf0ebe32c981bfa3db252cb5fc3bb1bf2e77 upstream.

When crypto_alloc_acomp() fails, it returns an ERR_PTR value, not NULL.

The cleanup code in save_compressed_image() and load_compressed_image()
unconditionally calls crypto_free_acomp() without checking for ERR_PTR,
which causes crypto_acomp_tfm() to dereference an invalid pointer and
crash the kernel.

This can be triggered when the compression algorithm is unavailable
(e.g., CONFIG_CRYPTO_LZO not enabled).

Fix by adding IS_ERR_OR_NULL() checks before calling crypto_free_acomp()
and acomp_request_free(), similar to the existing kthread_stop() check.

Fixes: b03d542c3c95 ("PM: hibernate: Use crypto_acomp interface")
Signed-off-by: Malaya Kumar Rout <mrout@redhat.com>
Cc: 6.15+ <stable@vger.kernel.org> # 6.15+
[ rjw: Added 2 empty code lines ]
Link: https://patch.msgid.link/20251230115613.64080-1-mrout@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/swap.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -897,8 +897,11 @@ out_clean:
 		for (thr = 0; thr < nr_threads; thr++) {
 			if (data[thr].thr)
 				kthread_stop(data[thr].thr);
-			acomp_request_free(data[thr].cr);
-			crypto_free_acomp(data[thr].cc);
+			if (data[thr].cr)
+				acomp_request_free(data[thr].cr);
+
+			if (!IS_ERR_OR_NULL(data[thr].cc))
+				crypto_free_acomp(data[thr].cc);
 		}
 		vfree(data);
 	}
@@ -1519,8 +1522,11 @@ out_clean:
 		for (thr = 0; thr < nr_threads; thr++) {
 			if (data[thr].thr)
 				kthread_stop(data[thr].thr);
-			acomp_request_free(data[thr].cr);
-			crypto_free_acomp(data[thr].cc);
+			if (data[thr].cr)
+				acomp_request_free(data[thr].cr);
+
+			if (!IS_ERR_OR_NULL(data[thr].cc))
+				crypto_free_acomp(data[thr].cc);
 		}
 		vfree(data);
 	}


