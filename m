Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423158468;
	Thu, 25 Jul 2024 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919062; cv=none; b=i8wIRwEQKVZ48FRUeVDa980u0+pVNMvaBDLf6P40Jc7dqdS67BKk5c6jQobD3bHC05Q6kgsjAF8u+dDcYPM6cJm9gqHyqPBT4n+byvyb4nUqs+NQnIGzRZQd0okoJpVlan5kszzOwflKv2VYiwVUEAOWdeOGBacwFppnQEEbyXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919062; c=relaxed/simple;
	bh=/XF4w9e47b52DGFVOXW/mhpCrfnSiedyEoaiHTFMMTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnOOLb3b1e7e/wnTvBSTXRSHFqv0PHbsUO/A07Kt0IH9wYKHxXGBGHQUIcQp3LU7c7DZDLFKC3r9FdcrJXo9H586ZqTNB6DASz2mS8G0JgyGLMUkSoyXq7LtCmST4RYj+WsUmgbqLpR2liAu+skD9/OxzH899wfCKr1nnhvtDKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOWtA9/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOWtA9/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7337C116B1;
	Thu, 25 Jul 2024 14:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919061;
	bh=/XF4w9e47b52DGFVOXW/mhpCrfnSiedyEoaiHTFMMTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOWtA9/IQYMC61uzhUU4PCslCHJEcJXPT5RZz8HU7OGLdT0SEdp2tEhi2+ZMVP5u0
	 cwUrcC185k+IWGeX0lAxNg/l3JNctpQwzUtS27CSO1ER9xi0lww1rvW86Nub5I7tt0
	 fGZ54zOMAaqmmmiJBOrdzuZm39PzS8Zwi0rA3Q1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/87] ACPI: EC: Avoid returning AE_OK on errors in address space handler
Date: Thu, 25 Jul 2024 16:36:45 +0200
Message-ID: <20240725142738.895114762@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1896ec78e88c7..59e617ab12a51 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1321,8 +1321,10 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
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



