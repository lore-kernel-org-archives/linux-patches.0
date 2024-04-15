Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4E274C0C;
	Mon, 15 Apr 2024 14:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191166; cv=none; b=gv0zoS4nhD+AOgssJ4O6A81Sgy1TF7YL+VKxaisOL3WQJ82zOwd3XkZlwMPlbZu0BDTmTvduj+1nlxTB/5wpsal8DgyKXA5axKe3nmdXV39xU6nGvOCGsNNE04m6l/rJ5EP3naLAOoUPP+mYtWLlJXX4hqsN48ndZOtU8RmyaVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191166; c=relaxed/simple;
	bh=EfZALm3zP5kTTYsqGpg3+4KB+uSfKfWJinRdF1o97bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPMHiwYQL0ag41Z+LTozKNw5yejEsFIx3wAphhDH9PJoxBv9mNIQe5JrcUWbwpAkLhOCrngdKYUZA/osgi4D2bMYwlyB9eT5YI/pDyly6WsO56gRkeU/lEiGNvGAVGPpcb6wsBjbmbUG0lFvc8nBweImTTWPFCi1dx+kYG3vR7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNwpsquk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNwpsquk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CA6C113CC;
	Mon, 15 Apr 2024 14:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191166;
	bh=EfZALm3zP5kTTYsqGpg3+4KB+uSfKfWJinRdF1o97bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNwpsqukMwbfUrmmS5I8xGKDGzpTqQbtwaRHeWLl/QamBqEd/OLxLurWox55eMdRo
	 /scrist6KqfHv5sE0BXbIofwwsJXslOVT+6xuKwqmOujKwtI8Nq4emchgjyt7CEe/E
	 6g0uAEKgbVU1fTw4iyLNJC2XC6ijxwXZHTmzJk/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.8 016/172] ACPI: scan: Do not increase dep_unmet for already met dependencies
Date: Mon, 15 Apr 2024 16:18:35 +0200
Message-ID: <20240415142000.846001704@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit d730192ff0246356a2d7e63ff5bd501060670eec upstream.

On the Toshiba Encore WT10-A tablet the BATC battery ACPI device depends
on 3 other devices:

            Name (_DEP, Package (0x03)  // _DEP: Dependencies
            {
                I2C1,
                GPO2,
                GPO0
            })

acpi_scan_check_dep() adds all 3 of these to the acpi_dep_list and then
before an acpi_device is created for the BATC handle (and thus before
acpi_scan_dep_init() runs) acpi_scan_clear_dep() gets called for both
GPIO depenencies, with free_when_met not set for the dependencies.

Since there is no adev for BATC yet, there also is no dep_unmet to
decrement. The only result of acpi_scan_clear_dep() in this case is
dep->met getting set.

Soon after acpi_scan_clear_dep() has been called for the GPIO dependencies
the acpi_device gets created for the BATC handle and acpi_scan_dep_init()
runs, this sees 3 dependencies on the acpi_dep_list and initializes
unmet_dep to 3. Later when the dependency for I2C1 is met unmet_dep
becomes 2, but since the 2 GPIO deps where already met it never becomes 0
causing battery monitoring to not work.

Fix this by modifying acpi_scan_dep_init() to not increase dep_met for
dependencies which have already been marked as being met.

Fixes: 3ba12d8de3fa ("ACPI: scan: Reduce overhead related to devices with dependencies")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/scan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1802,7 +1802,8 @@ static void acpi_scan_dep_init(struct ac
 			if (dep->honor_dep)
 				adev->flags.honor_deps = 1;
 
-			adev->dep_unmet++;
+			if (!dep->met)
+				adev->dep_unmet++;
 		}
 	}
 }


