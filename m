Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C981914A4E7;
	Tue, 17 Dec 2024 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456181; cv=none; b=DP1MwwknBms/nptBLeHBaiZm1XxJqJN3GUtsKLocnOKhqnF6hVFsdp1J23Yzk1R/6IKc8sG9NuTzZKfEEXYQW65pJ7RzfCydDmDfmkWRQlTnSdLjhc0aCWUb24mDAPqVUeZxCuWGS7izjlUs0U05qdB8BPY5WuvS6dDhP4M/T+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456181; c=relaxed/simple;
	bh=tu8dvgXN3QOoqYwDL9gf1+zNzer3AU55LUv8jVTjvLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbGb2ZH3J5GOsrcdSwnv/JojSSFCJTwc6SvXtCVuMNgfHU2jVrsec/0EZ3cbpOZ95ZZhbyz8tWcutEK2ZPd/tsqEW2JQ/kT85erpqhWoZwBQ8YdsIojbegKzjy3CFvmaPySrNHPm12ZRHsnaBhQt+e2aMf7OyIqv92GhhDI4BQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2wabns5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2wabns5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BEDC4CED3;
	Tue, 17 Dec 2024 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456181;
	bh=tu8dvgXN3QOoqYwDL9gf1+zNzer3AU55LUv8jVTjvLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2wabns5WAEB4J5mI7HDbBFUdJ+qHjl9PY9vS4YKVHJRS2QBHsFnn6WjOfIfWZC9b
	 L2Q/4pQvW7NQBi4MVo7AtENO9Yylvw84F2NvPDKStws5y1fn2ERegXvPKtPDEw3FEI
	 uJvIsseIJAo8PFDZ9umwZAbj8hXmeCqA1LaXjego=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/109] ACPICA: events/evxfregn: dont release the ContextMutex that was never acquired
Date: Tue, 17 Dec 2024 18:08:09 +0100
Message-ID: <20241217170536.928503770@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit c53d96a4481f42a1635b96d2c1acbb0a126bfd54 ]

This bug was first introduced in c27f3d011b08, where the author of the
patch probably meant to do DeleteMutex instead of ReleaseMutex. The
mutex leak was noticed later on and fixed in e4dfe108371, but the bogus
MutexRelease line was never removed, so do it now.

Link: https://github.com/acpica/acpica/pull/982
Fixes: c27f3d011b08 ("ACPICA: Fix race in generic_serial_bus (I2C) and GPIO op_region parameter handling")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Link: https://patch.msgid.link/20241122082954.658356-1-d-tatianin@yandex-team.ru
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/evxfregn.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index 95f78383bbdb..bff2d099f469 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -232,8 +232,6 @@ acpi_remove_address_space_handler(acpi_handle device,
 
 			/* Now we can delete the handler object */
 
-			acpi_os_release_mutex(handler_obj->address_space.
-					      context_mutex);
 			acpi_ut_remove_reference(handler_obj);
 			goto unlock_and_exit;
 		}
-- 
2.39.5



