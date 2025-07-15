Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B60E2C327B;
	Tue, 15 Jul 2025 13:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586134; cv=none; b=Byt80naSsPz300rQwkUGBHqIJ155IZkYjSdYfZOFzypYNNgVa7eMy1qKf7Rek44kfCX3kxOiuEs7NjMgV5HrZXoto3QRnYTXngk0ARq4Gy2d2xpdLOfU1anLjhqxE/DjY3Kwy/bL1TvUY1ehKmufObXj8a9vtwR6iVbbCfqJ+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586134; c=relaxed/simple;
	bh=RmbVBn3KRMX7xnGdbfqmDiRhymKUlPRrY0U3JFx+xwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKPmyJz7rb4yWpebQSkJmeE5gWfUwoT+Fxj6qcA7bQ0nTUDL/kIJoZqPyLQkOTjX8T8aqv6T5Yh/7catBtM1fNUhNQXZdZ4WJTxXzrigNQeGDK4wtmzx2MRKqtVrxCTcQqnAK1kgIK3LG59tF3uoE45i+uE91EbZsTIcB/yyBcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewqohawn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewqohawn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1316C4CEE3;
	Tue, 15 Jul 2025 13:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586134;
	bh=RmbVBn3KRMX7xnGdbfqmDiRhymKUlPRrY0U3JFx+xwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewqohawnpG7c9ziBe+wOXnRwgk5dkqd8QzXw/+vVDNwSlMT917DuMommxM51YkOEt
	 cmYFMOtxx6qjQJDMoYxUtDhkQF4rwIOwQhnz8K8qzj+0WvD7mvNYlTyluWQu97tlLl
	 9MvzRG6GKwOIePxv3TNlNM4ZRSomiv8Wx+9NONiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aijay Adams <aijay@meta.com>,
	JP Kobryn <inwardvessel@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 28/77] x86/mce: Make sure CMCI banks are cleared during shutdown on Intel
Date: Tue, 15 Jul 2025 15:13:27 +0200
Message-ID: <20250715130752.837504020@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

From: JP Kobryn <inwardvessel@gmail.com>

commit 30ad231a5029bfa16e46ce868497b1a5cdd3c24d upstream.

CMCI banks are not cleared during shutdown on Intel CPUs. As a side effect,
when a kexec is performed, CPUs coming back online are unable to
rediscover/claim these occupied banks which breaks MCE reporting.

Clear the CPU ownership during shutdown via cmci_clear() so the banks can
be reclaimed and MCE reporting will become functional once more.

  [ bp: Massage commit message. ]

Reported-by: Aijay Adams <aijay@meta.com>
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/20250627174935.95194-1-inwardvessel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -542,6 +542,7 @@ void mce_intel_feature_init(struct cpuin
 void mce_intel_feature_clear(struct cpuinfo_x86 *c)
 {
 	intel_clear_lmce();
+	cmci_clear();
 }
 
 bool intel_filter_mce(struct mce *m)


