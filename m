Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8791DE8A0;
	Tue,  8 Oct 2024 12:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392201; cv=none; b=Ok1x1kwdOnUOPQCak4QFLBrcY7Pd7M8Uo29cnEOey1+KDxhB4KHuiCoaHfitbU8d2v0bRk2/fVu6Ih+2FtcC3lg4xs9AKJIvNPiOapW+WWoogIqnE/h6MCohjHL7EaLN/pvDXx2w0dnzY/QtMHdWAfShwiPqsTjS6bq+RSy3mFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392201; c=relaxed/simple;
	bh=6U/+5H2HDpqoHs6RI4YUqKAEy63Io9JASbGUEtqCPzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btefDs8IbfveLKf7EdHauv9xsXdF0wKyH7gPzCvH1Ge2BRa8aidqGOHKWwTs7qr3ApD2aMTs5sFgzBQL2n5oQv6fHewFrMJj3MlpCHXas+HR5EmK9vWls2KEeQjutdWt9YWtL+VZj/sZGXvo4nzzsd9ruQDQr9Rk/VNvQ4vji/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzOAjhf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzOAjhf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C5BC4CEC7;
	Tue,  8 Oct 2024 12:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392200;
	bh=6U/+5H2HDpqoHs6RI4YUqKAEy63Io9JASbGUEtqCPzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzOAjhf/cgNYcksVCuBA/Gk9dR9kyOrtQk5kvuxXOYD+H9kddb4TmN2BvGCpjbBj0
	 O2EXQaGYef42H0GEZJms6tYTljywG4iY14tmeuhoB7gJNnadG8/dR3gOfq1HvtViwQ
	 cb5PbS3L12tDas+oPCObnb8/mIVQhOi6J8n7XhwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cheatham <Benjamin.Cheatham@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 314/558] EINJ, CXL: Fix CXL device SBDF calculation
Date: Tue,  8 Oct 2024 14:05:44 +0200
Message-ID: <20241008115714.667369806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Cheatham <Benjamin.Cheatham@amd.com>

[ Upstream commit ee1e3c46ed19c096be22472c728fa7f68b1352c4 ]

The SBDF of the target CXL 2.0 compliant root port is required to inject a CXL
protocol error as per ACPI 6.5. The SBDF given has to be in the
following format:

31     24 23    16 15    11 10      8  7        0
+-------------------------------------------------+
| segment |   bus  | device | function | reserved |
+-------------------------------------------------+

The SBDF calculated in cxl_dport_get_sbdf() doesn't account for
the reserved bits currently, causing the wrong SBDF to be used.
Fix said calculation to properly shift the SBDF.

Without this fix, error injection into CXL 2.0 root ports through the
CXL debugfs interface (<debugfs>/cxl) is broken. Injection
through the legacy interface (<debugfs>/apei/einj/) will still work
because the SBDF is manually provided by the user.

Fixes: 12fb28ea6b1cf ("EINJ: Add CXL error type support")
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Reviewed-by: Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>
Link: https://patch.msgid.link/20240927163428.366557-1-Benjamin.Cheatham@amd.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/einj-cxl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/einj-cxl.c b/drivers/acpi/apei/einj-cxl.c
index 8b8be0c90709f..d64e2713aae4b 100644
--- a/drivers/acpi/apei/einj-cxl.c
+++ b/drivers/acpi/apei/einj-cxl.c
@@ -63,7 +63,7 @@ static int cxl_dport_get_sbdf(struct pci_dev *dport_dev, u64 *sbdf)
 		seg = bridge->domain_nr;
 
 	bus = pbus->number;
-	*sbdf = (seg << 24) | (bus << 16) | dport_dev->devfn;
+	*sbdf = (seg << 24) | (bus << 16) | (dport_dev->devfn << 8);
 
 	return 0;
 }
-- 
2.43.0



