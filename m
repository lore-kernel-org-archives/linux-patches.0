Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F46C1F868D;
	Tue, 17 Dec 2024 17:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455405; cv=none; b=VA5oqwVqbRhfQk6KXvMSsKppFjdjJJZwXCDEUN/9tBxaddOKKgi0Ti0JkaTsXhKPsIHaRy339JxlXrnVddVgCn8Y43yhHoADtSo1Hp3Id2+z29y9rqz6M9YdMOutZw2g1yAWAX2e67u7LQFy57wtj+WpwdjOHOsPAn5pADN6AgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455405; c=relaxed/simple;
	bh=IGHlFQodvhRaKdz2CHqLemRGi41pGXb6w99ExZeKj9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dsor26oDFW9wzqs0PIKojuAMUuZ2W0iIbeo5uAgqJ/2V2S5z9umYm2KlEerxOkMAGWvVRv4CFHI+0qDDne1PZvBtgs4n20xvbNlV3HaB1goO/d7T8JiEpK+PRYzDzpNF+nOeMlcujgXzuxioiM3k9dcwWy6Bo8b06KkojMwPTSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSf4zbvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSf4zbvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E0DC4CED3;
	Tue, 17 Dec 2024 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455405;
	bh=IGHlFQodvhRaKdz2CHqLemRGi41pGXb6w99ExZeKj9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSf4zbvuqtyR3eRp4NoNFhw6fOvTRZ15AYFFsmumj6M4yLGHmgVN/y6Gpyqe+G42E
	 2+tj++B+RoajqKXubc7ZH0m5eS86l45MIiciJYJpVcNTrgUM1+I7h/brHMozChDXxK
	 eQ5lI6pqANT2qe9qYlDUzLHObYIRTrrLKeJAglyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/24] ACPICA: events/evxfregn: dont release the ContextMutex that was never acquired
Date: Tue, 17 Dec 2024 18:07:15 +0100
Message-ID: <20241217170519.713777558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6e0d2a98c4ad..47265b073e6f 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -201,8 +201,6 @@ acpi_remove_address_space_handler(acpi_handle device,
 
 			/* Now we can delete the handler object */
 
-			acpi_os_release_mutex(handler_obj->address_space.
-					      context_mutex);
 			acpi_ut_remove_reference(handler_obj);
 			goto unlock_and_exit;
 		}
-- 
2.39.5



