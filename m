Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8744D1E485;
	Tue,  8 Oct 2024 12:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390756; cv=none; b=oHf8tAoJjayGL6MU40g80J560xEWg+hynRs5UlgJ+R6jbgtQCbi72xH5AFTZG9WrhkXK7/cFbGhSRmov8o6aYN8lSZCvkxX8jgzwoy1PjCHNxAYyqf+JnK5IViW9oH3ktCXoFD24QcapC1Ybsc75/3PWljC2bqL32IDRvGJQtbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390756; c=relaxed/simple;
	bh=GYYUd2a+h/hstfvFn1PP45iC9FBS5QMAGhFSdLUGZNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R602RQOyXncZIzQPYWOtaxO6Tbf4YSCOIMRIOVc/JuzkUjJ/LCZy42B6VRLLTa5ED3JR1pDF40O2hnAfrcO+0ziMEjxYWqGq0czTFoRuRiPsgiuDOFQBQmAJcqctOwoRG/JGJ5/sZbr6VqjjNW2RhXODhdOD5cn5EXlkulHaAoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzsjuytD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzsjuytD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEB7C4CEC7;
	Tue,  8 Oct 2024 12:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390756;
	bh=GYYUd2a+h/hstfvFn1PP45iC9FBS5QMAGhFSdLUGZNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzsjuytDPNfK4thSA7nPVW94iVJ+afem9Su2mNlizadftK7pQloL0o4pgbqwl/tlr
	 DN5Gqs/HSfDdxF5tHEFpKB/zPYSnT8ACy6usEgk37ZmcxUXGCTK5txqjgB/GglxQRk
	 nJIhqVMSaVfBd3UTdyFYqzebxH54SZ364NAnuBTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Beleswar Padhi <b-padhi@ti.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.10 383/482] remoteproc: k3-r5: Fix error handling when power-up failed
Date: Tue,  8 Oct 2024 14:07:26 +0200
Message-ID: <20241008115703.489532674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kiszka <jan.kiszka@siemens.com>

commit 9ab27eb5866ccbf57715cfdba4b03d57776092fb upstream.

By simply bailing out, the driver was violating its rule and internal
assumptions that either both or no rproc should be initialized. E.g.,
this could cause the first core to be available but not the second one,
leading to crashes on its shutdown later on while trying to dereference
that second instance.

Fixes: 61f6f68447ab ("remoteproc: k3-r5: Wait for core0 power-up before powering up core1")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Acked-by: Beleswar Padhi <b-padhi@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/9f481156-f220-4adf-b3d9-670871351e26@siemens.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1332,7 +1332,7 @@ init_rmem:
 			dev_err(dev,
 				"Timed out waiting for %s core to power up!\n",
 				rproc->name);
-			return ret;
+			goto err_powerup;
 		}
 	}
 
@@ -1348,6 +1348,7 @@ err_split:
 		}
 	}
 
+err_powerup:
 	rproc_del(rproc);
 err_add:
 	k3_r5_reserved_mem_exit(kproc);


