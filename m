Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB241DEFCE;
	Tue,  8 Oct 2024 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390391; cv=none; b=ELf/4+ZBrXTVfk7eIVxWqAO2u4BtDd34rgoFd1jyRHDpHdCuD0jJbt1ykZGlGlX9C5x5JpZxrI9m0mEWdNW9ylJJiYYlOqnLid4rrjCRwCIZY6C7OgeemTcsFCaERiIZ++q1mkKq94wgboU1ApOK8TfsoINAGhqoNJlAyzx2yvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390391; c=relaxed/simple;
	bh=na/nyCLS/AWHOO1kW7TCGn5PUkYrfxAiOeYIScBjvkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxNsYAZqKNBLzeJPi1rhnymtxgKBZnUvvcEiEd5xXjwykytxE+QHV2vw1JFNtGSdJkq5K0Axb7Sgdu9jVDBodNSDdbOjrgDVHodjz7yuPdMb6+//YY8RJ6fqkcGijdBMcCCBpkoEuVxgYTFBqZm27cAIBdH1cK1mS6m5KbMguJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMLgUO3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMLgUO3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723D3C4CECC;
	Tue,  8 Oct 2024 12:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390390;
	bh=na/nyCLS/AWHOO1kW7TCGn5PUkYrfxAiOeYIScBjvkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMLgUO3xXoZ2OoOlYOjNo2UxzkBiORkYGmpGuFtGZcv6VEh91X7Zne9MHa0dbem8B
	 Mm0p4n6/yI2h05Hmq+tENyfXEQK8PRXOEGl+k+ZFMTHWZt65qXl+LoRWRVhJnyGHC/
	 gHG9ydDVGCAlyOjRHbCb+epo+ir/HdrySVlB3dj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cheatham <Benjamin.Cheatham@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Srinivasulu Thanneeru <sthanneeru.opensrc@micron.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 258/482] EINJ, CXL: Fix CXL device SBDF calculation
Date: Tue,  8 Oct 2024 14:05:21 +0200
Message-ID: <20241008115658.438351622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



