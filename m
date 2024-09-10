Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3560723A6;
	Tue, 10 Sep 2024 10:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965214; cv=none; b=Y+TKLvoMfyl/f/CvQCH7vcqGNFtB9tWhiSwuMoWWiaLBujGnXiok2JZU/R2ypQhmygQanMZhDkZgcx6EEeT6I5tQH3l5xh9vNV8f3GPXuISu6qhVp0iJ6DKfsi6lJLmA+Abu7s2wYHHnWhRHDBYRGcrcyuxzrI+osISo1yeOuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965214; c=relaxed/simple;
	bh=aIfvCJLk5VaVtBxJrbNtMbjVM3t0dkalYulfg9i3EuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqrT6q5WYsjfR/KPY7ylV3FC75NGOUPBNgZ8/cUBvjNK9Jek12APbermT03RbtmoWB3KQyBkIEVNHMglYuT8Xn5fhc3iFjcAnalF4lr+3+zKhfF1c80PMnpsXwsMbXAdN/X64DP2oh/ynXgfsK3yPaY+4ztGA/II0SojEW2Twko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0VfCtZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0VfCtZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF019C4CEC3;
	Tue, 10 Sep 2024 10:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965214;
	bh=aIfvCJLk5VaVtBxJrbNtMbjVM3t0dkalYulfg9i3EuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0VfCtZcx6IpPZNWd8I7pOmQujPn68s5orIjcOCOFYomLmfF81JbmpvT9B8SsSt7J
	 Iar60IQEsZG2v9A9YQRnHfGRwfaWJhXD+SitjcerZUuaU9gViwZex0qXrjRe/ue733
	 fAvpajZfzSl1kj8/n83cZUTv5CjcqBuKJAVnTY0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/186] ACPI: processor: Return an error if acpi_processor_get_info() fails in processor_add()
Date: Tue, 10 Sep 2024 11:34:30 +0200
Message-ID: <20240910092601.833068138@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit fadf231f0a06a6748a7fc4a2c29ac9ef7bca6bfd ]

Rafael observed [1] that returning 0 from processor_add() will result in
acpi_default_enumeration() being called which will attempt to create a
platform device, but that makes little sense when the processor is known
to be not available.  So just return the error code from acpi_processor_get_info()
instead.

Link: https://lore.kernel.org/all/CAJZ5v0iKU8ra9jR+EmgxbuNm=Uwx2m1-8vn_RAZ+aCiUVLe3Pw@mail.gmail.com/ [1]
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240529133446.28446-5-Jonathan.Cameron@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 2ee5e05a0d69..9702c1bc5f80 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -387,7 +387,7 @@ static int acpi_processor_add(struct acpi_device *device,
 
 	result = acpi_processor_get_info(device);
 	if (result) /* Processor is not physically present or unavailable */
-		return 0;
+		return result;
 
 	BUG_ON(pr->id >= nr_cpu_ids);
 
-- 
2.43.0



