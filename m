Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A8547887F;
	Sat, 12 Sep 2026 13:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218691; cv=none; b=u/D7CjE4eUEUKjEqul5oY6KKbKe1lcthJK2PDmGFj7y7C102Iqp9UUx2nRYgojrtKqp1A/wVAWpleOwwnjD6jZMrXK3SOBD4C+Ez0xbAaXipDBoVksQYdB9YXCzdAs2GQpM098uJff1HGCDtjk0mhwXkg1rq312FIaRfRFhQkiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218691; c=relaxed/simple;
	bh=318NGNeL7tSeFZMWxpY/2/IjHGRd9BcaouDsY3p3PHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZVZGELy9guXxYEC1G0J0vukjht25lsHk+pN5h3MPvl+yli1ptqZpsmlmFMTbZnQl7Kj32q0AXeODZ+cFf30r+XgHBFERiXnmhfapI7llQcg8Yze9uN1AaRTcJidW7Ucgi2ZggKMi0j9RSnJB+Ir/6a5EmaCTM6BvXkkLnGFNco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1Ebw+od; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1Ebw+od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51CA1F000FF;
	Sat, 12 Sep 2026 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218690;
	bh=5y3B0eRs0+Wo9dgMO2XnOK1sBiBtDGzpBeeJKcxFKYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1Ebw+odkpj9YzYFJ959qV5VwTJyC/+qBLYAyUrDL5Hv/GTK1CxruBdvbjcDun5S/
	 sPEXTGyx6EbuxHWZWUEZvTP0AkJakJeOZOjVIBV/Hn3cDZud2wBmB1PYf3uDZBAoZG
	 9yY6L+5haenMUZQdiG27hE3TsIfcFtqaou1cI2Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1159/1376] hwmon: (coretemp) Fix core_data leak on CPUs without PTS
Date: Sat, 12 Sep 2026 08:59:45 +0200
Message-ID: <20260912065633.384936286@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 1b9203b20d709..afa481b08c8eb 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -656,6 +656,7 @@ static void coretemp_device_remove(int zoneid)
 	struct platform_data *pdata = platform_get_drvdata(pdev);
 
 	ida_destroy(&pdata->ida);
+	kfree(pdata->core_data);
 	kfree(pdata);
 	platform_device_unregister(pdev);
 }
-- 
2.53.0



