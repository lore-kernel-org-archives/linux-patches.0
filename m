Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC31F222D67;
	Thu, 12 Dec 2024 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020402; cv=none; b=nyT6mX1YLpZ80WDyq7pWQrtw4ylVQYg19jTvn7fuIeAnyfv/miCKVAHHdpKQ5diUHHO+YMUHKOwafJkkTCpaqTxP0wM6taUlq8+kZv5sN8N4q+QrEGpD/NZtMe0yUGvn+zBzItiPxmBbS4trHtKr6/0hSMI+XaRI6h0K9eRB6Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020402; c=relaxed/simple;
	bh=HhpIgwjfFtB0E5ujJecn/rTrtswxSq4Qg9XCEcTqsOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ku0tW9hb3aGW3ZA7QNcUJsr/pSxjGYpAlvWSbO8jw0iWsu52Fl3Puos1jhRsxw7etdI2oG8OVT+7eQBSD5x55Rn0PSqtuz0L8U6WZv6ZkWPJj4qJWWrTh41I3khBL7P5Gk8N/j/6kVD2l1m3PEchJ771CBl7k5CEqTV4IQXUNxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9Mdc1oL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9Mdc1oL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003CAC4CECE;
	Thu, 12 Dec 2024 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020402;
	bh=HhpIgwjfFtB0E5ujJecn/rTrtswxSq4Qg9XCEcTqsOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9Mdc1oLMvxrPVRh20iIYnXzrVvBKoHWGGgQtndUaf7ArUlOhmyDRjYbNfot5JI3i
	 Jm2GGiP4+TQ90vfBD8fP/ssqSdZ5MrHnmMAD8gBSzX1Dchp4Oe8pEaylIiKZBBJKAE
	 aP6pSJ50E/B5GmQnenJYka8H9bLmCH3yDrJgMa1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 428/772] um: Always dump trace for specified task in show_stack
Date: Thu, 12 Dec 2024 15:56:13 +0100
Message-ID: <20241212144407.608754223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 0f659ff362eac69777c4c191b7e5ccb19d76c67d ]

Currently, show_stack() always dumps the trace of the current task.
However, it should dump the trace of the specified task if one is
provided. Otherwise, things like running "echo t > sysrq-trigger"
won't work as expected.

Fixes: 970e51feaddb ("um: Add support for CONFIG_STACKTRACE")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241106103933.1132365-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 746715379f12a..7e897e44a03da 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -53,5 +53,5 @@ void show_stack(struct task_struct *task, unsigned long *stack,
 	}
 
 	printk("%sCall Trace:\n", loglvl);
-	dump_trace(current, &stackops, (void *)loglvl);
+	dump_trace(task ?: current, &stackops, (void *)loglvl);
 }
-- 
2.43.0



