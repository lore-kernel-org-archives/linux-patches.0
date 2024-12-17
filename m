Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64ECD1F76DF;
	Tue, 17 Dec 2024 17:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456829; cv=none; b=V2jHcj7ivpK6k4GtlyRn9DI/zc7hORHj428c2hjRewipmZOc7CUQ6q5DNXm7MaROOYZEBogL7P2924Sk51XeyO1S7w8CYBAIDN9JpZnE6tX9ItkCla401PGIlPwi/ymOY3y6TXjbKCbf0Hv8tEn/jYAFPUn3/K9jp2PVwD9aJ7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456829; c=relaxed/simple;
	bh=f4mVSYpu15NVGTJGEAatjHwBR/xizC9Mffjnbvk3c5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hw64/DoRY/FFRKIwko00CV4HFwn4qfrIzehtNtdyUkSy0cho35McIM6XPgx6Ii+uKZQ4Lq9m7Jdhf1tmSHZu5zqCy5G168M0h40/lQH73LT8Y6RVwHSmHxqlqhrLD1q5elEJwfHwYcvZpRT8fpuMukgWX66vn/+fugVwcnXcxZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyUFPWk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyUFPWk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D878CC4CED3;
	Tue, 17 Dec 2024 17:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456829;
	bh=f4mVSYpu15NVGTJGEAatjHwBR/xizC9Mffjnbvk3c5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyUFPWk1r9ewugQQ9qrFw9K9/cTLTt324KYWLAJsJthXFToW1V9pKKvTnGQsE0tjM
	 89V6bDUbp5aq7ZfItfaXNaonPtreJYv5C2cWnp5WiYO0bIKrpg1fguOmDptwgr4L1+
	 9it3gwNXeQUgz5l5lvp434On68imwI8wBHww+O5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/172] ACPICA: events/evxfregn: dont release the ContextMutex that was never acquired
Date: Tue, 17 Dec 2024 18:08:22 +0100
Message-ID: <20241217170552.386520209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



