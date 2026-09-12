Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF2F37FF60;
	Sat, 12 Sep 2026 09:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203871; cv=none; b=DIb+zT73GgYVuXe1sCElEJw2zPPPWC9pI8nxcgDHugMtJAu/Qa3KYERo1PJxwVe8wrjhJFleh9B2wdZK0HCOfUdmOJS72tkgATnJ7MeuLweFQXEqcBi8Nch/Z3R/2/LUMBZBdh/ukgqh/+byYMPda6h+Jkcqxr/IvxHzgpvZ4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203871; c=relaxed/simple;
	bh=Jr9CyV/X36YgobW4CqCKmIqHCkwyT2TUhwCQZj52ZQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGwRo25jwJgpq5fbvDO+dJnmRiLrQhrDsaBc8fsvPTlGfpp9aqBL97AaHgIzg+z9OqmbtUZOkVPPMHSPj/Vyy+fW2/vrLHr4Yf4tA18ysn1F3vmuo9/y9c7jbD9mM5Le+Rh9/JGPekyQaySFPCsX8dTzZzEntjZY3S6uYQhIuJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zB7vVa2U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zB7vVa2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08A61F000FF;
	Sat, 12 Sep 2026 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203870;
	bh=uxNJJrym5aPHbyFRVtxLXyzRQS1TM2Wq1Z8ZzJ1iifo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zB7vVa2U88Yzn7xNv2CK7ZBtcBCCuJqr0lB2Ht2x2Fh9S9XuVFB+7CPxTvSqwWcbl
	 RmbTW5HfZj9d8lcT6bjJad/6b+19IOJ6hwyS4ZIKtpG8ZqKfQjGzaeCO4Nl1ixUMsX
	 FnN9g2e36w3kGg12VD596+ExNmdj3r+ZE4Kj7u8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1495/1815] hwmon: (coretemp) Fix core_data leak on CPUs without PTS
Date: Sat, 12 Sep 2026 08:54:05 +0200
Message-ID: <20260912065724.097875852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Wilczek <swilczek.lx@gmail.com>

[ Upstream commit 0cd8450c257faa0cece0e0c43d3b55d1a389acc7 ]

pdata->core_data is allocated in init_temp_data() when the first core
temp_data of a package is created, but it is only released from
destroy_temp_data(), and only in the branch that handles the package
temp_data.

Package temp_data is created solely when the CPU supports
X86_FEATURE_PTS. On a CPU without it, coretemp_cpu_online() never calls
coretemp_add_core() with pkg_flag set, so pdata->pkg_data stays NULL.
coretemp_cpu_offline() then skips the removal of the package interface,
destroy_temp_data() is never called for package data, and the array is
still allocated when coretemp_device_remove() frees the platform data
that pointed at it.

Release the array in coretemp_device_remove(). destroy_temp_data() sets
pdata->core_data to NULL when it frees it, so the added kfree() is a
no-op on CPUs that do have PTS.

Tested on an Intel Core i5-1135G7. The driver was instrumented to log
every allocation and release of pdata->core_data, and the PTS check in
coretemp_cpu_online() was patched out to emulate a CPU without package
thermal support. Without this change the array was allocated and never
released, and coretemp_device_remove() still saw a non-NULL pointer.
With it the array is released and the pointer accounting balances. On an
unmodified build the release still happens via the package temp_data and
the added kfree() sees NULL, with no slab warnings over repeated module
load and unload cycles.

Fixes: 1a793caf6f69 ("hwmon: (coretemp) Use dynamic allocated memory for core temp_data")
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
Link: https://lore.kernel.org/r/20260810192344.3733721-1-swilczek.lx@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 6215ea49faaa9..ab9c8cbf887aa 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -650,6 +650,7 @@ static void coretemp_device_remove(int zoneid)
 	struct platform_data *pdata = platform_get_drvdata(pdev);
 
 	ida_destroy(&pdata->ida);
+	kfree(pdata->core_data);
 	kfree(pdata);
 	platform_device_unregister(pdev);
 }
-- 
2.53.0



