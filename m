Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59C4CCDC7;
	Fri,  4 Sep 2026 05:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500276; cv=none; b=NKpNu0//2EyXEs862ompEb83rqHlzUlbBYgB1+RUxHZrP1mSnzg7wInoZlI45aDhAyCBBSlY2aZYwhxNNeaohfpIMVqkNEUF+KJ87/Uq287aHIIl6MN9aQUByBIJ+65yEh+nbZtA7pnaXpYdfMUawBY5fITquN0yhtqbCxr63Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500276; c=relaxed/simple;
	bh=gw93FClnIwqvuqNHoB5+ujqg3L2P7EbjlNhpwvzkXg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tu9ToktPB1N5ukf1jCGZAr4TomWLVjG6OVQkw58f5JEGhFgW3TQqaXh/IlNa0YEzVNdwNqj2ztZmHdqzHN2n1UG5PcvfGrPylBSSda4oq0m3qY8whn9s9ywkjcOfmr2zb5o9w24QtgGhBQzkJf3sfTWAp6q8wFF/bCe2qzt3VNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERhE2WWj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERhE2WWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9121F00A3D;
	Fri,  4 Sep 2026 05:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500275;
	bh=RGOdj8vQnssgai++vfBjvBcWMtlZwenMmE5eVfNktmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERhE2WWjcAKE6BC6z0lszcB5GUl3HqtlxirK6nJgyuFg/4GE2IVHv1qNPbtlOZR6a
	 ROiZ3lTzQLEM1xM+z/DvZxS2SxSgpM2t4fPFgqng96UahXZbzycSkotb1ioGPwhyr2
	 ufttLg7qajioHlVcl7q9sOT+wwiyfbKnAGkDN7LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.2 712/713] ACPI: scan: Do not combine resources that overlap completely
Date: Fri,  4 Sep 2026 07:01:20 +0200
Message-ID: <20260904045819.807495029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 7617cc05df28dcae967cca109de74084321eaa62 upstream.

Commit f234fdaae1ca ("ACPI: scan: Avoid registering platform devices
with resource overlaps") attempted to avoid platform device registration
errors due to overlaps of resources of the same type returned by the
same _CRS object in the ACPI tables.  It did that by combining two or
more overlapping resources into one, but it went too far and also
caused resources that overlap completely to be combined which broke
the arm-cmn driver that expects two MMIO resources to be present for
each device it binds to and it expects those two resources to overlap
completely.

Address this issue by adding checks for completely overlapping
resources to acpi_platform_adjust_resources() and add a comment
explaining what is done there.

Fixes: f234fdaae1ca ("ACPI: scan: Avoid registering platform devices with resource overlaps")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-acpi/20260819003752.GA3063251@ax162/
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://patch.msgid.link/12955564.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_platform.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -85,7 +85,13 @@ static unsigned int acpi_platform_adjust
 	for (i = 0; i < count; ) {
 		struct resource *res = &resources[i];
 
-		if (resource_type(new_res) != resource_type(res) ||
+		/*
+		 * Look for overlaps of resources of the same type that would
+		 * cause resource insertion to fail down the road.
+		 */
+		if (__resource_contains_unbound(res, new_res) ||
+		    __resource_contains_unbound(new_res, res) ||
+		    resource_type(new_res) != resource_type(res) ||
 		    !resource_union(new_res, res, new_res)) {
 			i++;
 			continue;


