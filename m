Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689E444CAE6;
	Tue, 16 Jun 2026 15:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625300; cv=none; b=lkrvX+i/IeXkEBqioFIMbLCloLSbiiOaRDlRn3X3Lq0BokMQCjWxXJ8mOhvhoBxG5zogmWUXpVKz1VSsnKIzNdPvYv99bB+gDltm14R2KFOmE8ReKjpIljO86UGeE7hhAY8gGGwMoOrR5aOgsAuUUqE7d1msZ4zMjNjsmZ2MtAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625300; c=relaxed/simple;
	bh=G0Oz1UyF58N/cK12FxQSG53+In5X16rvb5NmhhfTcn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuHFTuz09NoV5RBFfK03zUIMke+yaGVVffYiqJofKZajfWUvJ3m8S3pmUps+v+SGNMIo+4xpCA5dxU7YLt92KQftmYjJyRZv3IRSrXCVmSDMFv0aKSm8cd5lMeLs602qOsMp35bVKm99Vwec5HVSufcZbOoiUR6fhfqPHGDMnAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmSG0hGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmSG0hGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F251F000E9;
	Tue, 16 Jun 2026 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625299;
	bh=6Vm+wZIXKzmicEf3P+yPQuV9Z/4988kmy/s6cJN5Yok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmSG0hGqTAPqa8bCsSFDI+B5HLIrbsaY2MORrts89gD6FjXM/HnXf1jXcK9oILTxD
	 iyKSuNZiJc8h7uOheysQu4ZgGVkCMSaJtDOeYvoQMZYJKMPetFF3tDwMXnzb4aT85U
	 MnowHuN6OlRMjIeXAqglgqN2URst5NSMTL6bMeno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/325] tools/rv: Fix cleanup after failed trace setup
Date: Tue, 16 Jun 2026 20:27:58 +0530
Message-ID: <20260616145101.807498566@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 33ec2269a4155cad7e9e42c92327dcaa9aee59a7 ]

Currently if ikm_setup_trace_instance() fails, the tool returns without
any cleanup, if rv was called with both -t and -r, this means the
reactor is not going to be cleared.

Jump to the cleanup label to restore the reactor if necessary.

Fixes: 6d60f89691fc9 ("tools/rv: Add in-kernel monitor interface")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-5-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/src/in_kernel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
index e4f35940374f5a..e6dea4040f8f4c 100644
--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -810,7 +810,7 @@ int ikm_run_monitor(char *monitor_name, int argc, char **argv)
 	if (config_trace) {
 		inst = ikm_setup_trace_instance(nested_name);
 		if (!inst)
-			return -1;
+			goto out_free_instance;
 	}
 
 	retval = ikm_enable(full_name);
-- 
2.53.0



