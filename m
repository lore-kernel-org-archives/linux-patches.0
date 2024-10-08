Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7552C1DED74;
	Tue,  8 Oct 2024 12:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391400; cv=none; b=QWGxNMMY3XlIStheBbRPRpSh1TyVhczRAunAlov5GMN7a11qs2vbH6FsnsidGXqodTxTv7Fkqxz3LYdjFC4ATcxMpdzA/lCdqkSCm6ncOWjOn0Ab0tjZThVdr5LvAQUfSjnqtYAGepS3grPzodzgiZKZsDFN+A49LcsHwXmwuA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391400; c=relaxed/simple;
	bh=hlFe9+fb0I0YE88+ZUtHDt60svmTRMo34Zbr/uXX6S0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OE/gKjTQm0E4VS2tQXcTmKkxBZwdnb3P4Kzaka97+IZeMJbdv7ZXOJHTwEitxpQzSWaTtk0hmrz04Jw8iJBpngTjHh8BLmk5sESxcKJPy6OcZ7X5hNLoPgqBPfKdvTeDdNE1l/S0sTGQdoz+psv9gVOD1aLcjgrKv9c0ve2FUIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQf68+tV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQf68+tV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6368C4CEC7;
	Tue,  8 Oct 2024 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391400;
	bh=hlFe9+fb0I0YE88+ZUtHDt60svmTRMo34Zbr/uXX6S0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQf68+tVhOlkbDjxtMU65o0RGJ7hqaGJFW1KcG0Y64NbZGUpvxF/jf8xfDk609xek
	 g50HzAjMX1kXeqoenltYNURYs/pQCT7X3zj1GEljcYQ3+CPGb3nnAiPZIb+2Er2grs
	 EDCUKijjT4FtUZ2p91b5F4HfKW3Hlxsv2KgWrAqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 101/558] ACPICA: Fix memory leak if acpi_ps_get_next_namepath() fails
Date: Tue,  8 Oct 2024 14:02:11 +0200
Message-ID: <20241008115706.342467800@linuxfoundation.org>
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

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 5accb265f7a1b23e52b0ec42313d1e12895552f4 ]

ACPICA commit 2802af722bbde7bf1a7ac68df68e179e2555d361

If acpi_ps_get_next_namepath() fails, the previously allocated
union acpi_parse_object needs to be freed before returning the
status code.

The issue was first being reported on the Linux ACPI mailing list:

Link: https://lore.kernel.org/linux-acpi/56f94776-484f-48c0-8855-dba8e6a7793b@yandex.ru/T/
Link: https://github.com/acpica/acpica/commit/2802af72
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 422c074ed2897..7debfd5ce0d86 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -820,6 +820,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 			    acpi_ps_get_next_namepath(walk_state, parser_state,
 						      arg,
 						      ACPI_NOT_METHOD_CALL);
+			if (ACPI_FAILURE(status)) {
+				acpi_ps_free_op(arg);
+				return_ACPI_STATUS(status);
+			}
 		} else {
 			/* Single complex argument, nothing returned */
 
@@ -854,6 +858,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 			    acpi_ps_get_next_namepath(walk_state, parser_state,
 						      arg,
 						      ACPI_POSSIBLE_METHOD_CALL);
+			if (ACPI_FAILURE(status)) {
+				acpi_ps_free_op(arg);
+				return_ACPI_STATUS(status);
+			}
 
 			if (arg->common.aml_opcode == AML_INT_METHODCALL_OP) {
 
-- 
2.43.0



