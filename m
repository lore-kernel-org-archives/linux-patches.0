Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA8113D896;
	Tue, 23 Jul 2024 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759911; cv=none; b=MTbf0O6oKK8WNkkpLE9fYiOQ5OR2cLKxTEKZkfm7BRKfCwcMauwJeQC8ssvao4k6fPnr2GqEZ+Q5YstSgKrcvf7A1V12hJSmu3eJ6Wzu4RLtB1QP6xgJjwkBSBnNKe+C9AtBpwTWWQJkT8XqY0rFrs91jsTus4qcfQysq9k6+8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759911; c=relaxed/simple;
	bh=VIF7OkZSbmHg2UeqcrGVFJ2L40PhysZTE0Yxe5KIf2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pThrx1mHjQ1/YD0zdUl+RTY4pTlK9zpqxTTUXI+108YrP45d1NSnxPaoiaHTDVcljb14xesGpSozjgVj6Y3UkrE9yN79udTnBVH94BRD4akObDG2m8hzi39b3mUDwxFuJQmPNOX1EyxrXHwOqRk/Qtbg78Cx8/svi7uree5EI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mk6kkFeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mk6kkFeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3243BC4AF0A;
	Tue, 23 Jul 2024 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759910;
	bh=VIF7OkZSbmHg2UeqcrGVFJ2L40PhysZTE0Yxe5KIf2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mk6kkFeGEO3uOm/Gbus3NHOvbwkW6+ACLVhXTQOzI8SBqOGlP2qhYCN42CEQJk1k8
	 n0v2kiTypXNkJHVpx5Ljo1obRVxq9fpv1oYzP9fctKuS7th0qJ/r/6gYSLvOePZWhV
	 5mp4+38bsza0AOQvEQC2ovAwCsoButwTzErPl5SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 009/163] ACPI: EC: Avoid returning AE_OK on errors in address space handler
Date: Tue, 23 Jul 2024 20:22:18 +0200
Message-ID: <20240723180143.826850487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index b66e5971fd3d1..299ec653388ce 100644
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



