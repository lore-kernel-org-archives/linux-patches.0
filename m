Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051E242067;
	Tue, 23 Jul 2024 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759501; cv=none; b=YpXiuf4admEICHv3fzUMd8cR7q/7GaNZdWtPpKgAhmGeR8yee2Bw+91/mGYzc5y65FvwmSMzAa/LIxtrCvD8JfFNY1ICTwHG9vpAm8FVwsLtZGVe0BdhI1WZR0McJ/t7agKV3BgNA/grkK1jFNMyRXKlYG0HZl3Fb4dFu+M0/DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759501; c=relaxed/simple;
	bh=RNnHHuz+WUKxCaFCyVRQ2tuU/1LVW2/NFIbgF2XAbX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npknZSp+MhRmFwyMep71KMBb3mUegUT8LYIswPDjGgjCjk7IuV9gf5Q6nk9L7uYCC9BEW4cTZ6BHfXXBeDdZwEP5xt4L1T7gPv+brn3rESrALrpwUq67iHBSmIJRM+Zq9fA6E6AZbyLtC2X3rAFlalQfQi0cv8QRyJ/sdrM/G6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/Q/AkaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/Q/AkaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D862C4AF0A;
	Tue, 23 Jul 2024 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759500;
	bh=RNnHHuz+WUKxCaFCyVRQ2tuU/1LVW2/NFIbgF2XAbX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/Q/AkaBY4oqjNt0UhxwwdWlq3DUvimSo3pQd/11r/1aFR7msJhKwWykXGJs5B/YA
	 PczK+GmUCFMd+RIedAi8rQcMVcZFAyOywOeiBv6DQp2NGK+yyre6C4/vq3qSAzV6O5
	 Q2Uev/kW6Roz/UJgjAn9qurvhwWLjEebR/u/YmJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/129] ACPI: EC: Avoid returning AE_OK on errors in address space handler
Date: Tue, 23 Jul 2024 20:22:37 +0200
Message-ID: <20240723180405.140365616@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index 3a2103da6a21c..4e3a4d96797e0 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1351,8 +1351,10 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
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



