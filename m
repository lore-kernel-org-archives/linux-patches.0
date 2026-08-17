Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47B53B774B;
	Mon, 17 Aug 2026 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980038; cv=none; b=B0Z92g8rg87x2CKO4y0+5ci1EbweOd/Gs5iOOW1m1mL/6OAQ7zcf2gwCqRxhGTbs5f/GQpIMPgX01RdBx+yYvOZuxJAWH3jgnqOVuXBjDOMMj4T6KBauZYne2lUtp3XrGXvnpjJZbnalVD2RQIioHwi+shXzdg4WVK8/Uz3YVYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980038; c=relaxed/simple;
	bh=eIZWI0/NPgZlbiaWW9CaJSKWFj58Bj81GPg1t42xyfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+rNeAHQ7oLIEgOyJhZW9fZwNjkLewNzAwvYvaMMKyfpbigH8zfSVH9jwfmS+zK7g23/1wckK3PrjSHNq915we5QKjVozu+PrcGAF7Qq9zDDyZxws4RhlRrLpiOkBaQfwkTp00K9Gxzj+y/puJfLSBlnsEqESD4N7N+KK/41w3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrjGSd/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrjGSd/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBBB1F000E9;
	Mon, 17 Aug 2026 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980036;
	bh=tOm7FaQ2wFuQGDWjFJnpgVx0CyyaaQZiKDkkLWMhJxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yrjGSd/aIREgXhwdJ+nbgRlK08PS9PNEgerflQ6bq/EBIYua2Eab8W6KIhNRobidx
	 uLE87qGwjoXZXvNFHUG8/LxAMGbF8alsiBZABYjpDgmLFRn3cVY9rioWD5SFzqJdD/
	 15hHVNU+zRviCqTxs56fG7IhIQRRgRkdkfxG/cFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 433/609] cpufreq: powernow-k8: Fix possible memory leak in powernowk8_cpu_init()
Date: Mon, 17 Aug 2026 15:32:09 +0200
Message-ID: <20260817132558.571347618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit d5f8e5f6040d052d44fcbf4f31dd35145c0c8d7d upstream.

The memory allocated for data->powernow_table inside
powernow_k8_cpu_init_acpi() or find_psb_table() is not freed in one of
the error paths in powernowk8_cpu_init(). Fix that by adding a kfree().

Fixes: 1ff6e97f1d99 ("[CPUFREQ] cpumask: avoid playing with cpus_allowed in powernow-k8.c")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727093553.98246-1-nihaal@cse.iitm.ac.in
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/powernow-k8.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1083,6 +1083,7 @@ static int powernowk8_cpu_init(struct cp
 
 err_out_exit_acpi:
 	powernow_k8_cpu_exit_acpi(data);
+	kfree(data->powernow_table);
 
 err_out:
 	kfree(data);


