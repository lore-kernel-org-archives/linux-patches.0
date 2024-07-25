Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D718468;
	Thu, 25 Jul 2024 14:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918902; cv=none; b=PEluCU+iYDiEWORy2c1FmSV4O9DeQdFR2BdANWUV1QwnnsZ5/V8rloSzg3vfTPNGIKNF0HIFQ0FiJvPSnrht2YwgUkKrwzotj9kAZXNxhTnENsLY3jRxoTmaffaCkBKJmeRhQnQje/foETEZ8vKTlw/Z8oNiI7oOlMULiYpZZcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918902; c=relaxed/simple;
	bh=Gm4j7bWVd/HF+nqMtHDKyE8DuuRuZpgAOBT5IbR+CSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBuXsU2ckvv0p/3KY7a+BIBlPYRrURX9Lz1K/0tXWGQhuzl4XbEAGoNEsBcS8AeMOVYVgPA3JHZe83Y9XQvnodXcm+uM+maysKpdzcIyvTDvI/ENN9UxUIOvGftVcZk5PSeh46wsJm3fKmE0KbFDMjy2laSCvUAA23peYrg87Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLraQzN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLraQzN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C40C116B1;
	Thu, 25 Jul 2024 14:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918902;
	bh=Gm4j7bWVd/HF+nqMtHDKyE8DuuRuZpgAOBT5IbR+CSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cLraQzN6ZCPsJzMT761ExIadkWb5B70RC7mUcDEfVuLNn0TV89WdHdaKzDIyX8Hsb
	 p6rFqN99pycGM1KME66m7DO5UcC0xwfLGjU6E1w3DR5SHOArIUTMFD8hpSKQvJuWQJ
	 o0VAYFWr/xxl5aZJyUFTUEnipi+PU3QbVqot6HM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/59] ACPI: EC: Avoid returning AE_OK on errors in address space handler
Date: Thu, 25 Jul 2024 16:36:55 +0200
Message-ID: <20240725142733.468430499@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit c4bd7f1d78340e63de4d073fd3dbe5391e2996e5 ]

If an error code other than EINVAL, ENODEV or ETIME is returned
by acpi_ec_read() / acpi_ec_write(), then AE_OK is incorrectly
returned by acpi_ec_space_handler().

Fix this by only returning AE_OK on success, and return AE_ERROR
otherwise.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 60f49ee161479..01a6400c32349 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1334,8 +1334,10 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 		return AE_NOT_FOUND;
 	case -ETIME:
 		return AE_TIME;
-	default:
+	case 0:
 		return AE_OK;
+	default:
+		return AE_ERROR;
 	}
 }
 
-- 
2.43.0



