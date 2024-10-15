Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF85819B3FF;
	Tue, 15 Oct 2024 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993510; cv=none; b=hHTSF2mAicUqKkl7kwR/vk2f0DCQZKHjuefXGelwBX7/LcytRlyUx8MRYtzt9P1y538PWCo3mTweAle1To4976Gx/jpHBH2RPujrZTVNsH0vyLG9+eRiEsmnbhLf6IVh1as6mHDn5AqkSuY6PAY0ZeZ3Kvgyafmod6HiawM/lUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993510; c=relaxed/simple;
	bh=/40FNewEotMO6JNOxnMpXY3sYmjH/1XQxmL2mn6EPlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bT1ZRvHV28Hz/iOYU/OQcFDxf80RrPT+M630ByHZ9n1xEYNn5IcS2aCuOySm+SZgtdIi1BbVPaYPxfDqlGoSdNtT4rk/W9p6ADEw0YijjKHuZmXMo6nXGDeFHbu0b0Tyb9+FAd/a+fbBHj7PaeCZs4WyfFXSCrECuGWXoS8sxBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tzping7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tzping7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A60C4CEC6;
	Tue, 15 Oct 2024 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993510;
	bh=/40FNewEotMO6JNOxnMpXY3sYmjH/1XQxmL2mn6EPlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tzping7VsQj8Jpc53kkwGJE1RSK1pnYstzzqcoUSfzUV7OXhowqzJ0yG0a5LECtDP
	 gegclZWQJyIQFpAzlpcuwshLyfDtP9LeP9Rt2MYsj5CJitrXBt1LXN2KvBmmb5lhLw
	 /OmY4Wz6lYH5Z7O3mZ6yjUYEs74Lgp3Zvw7wN1G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 416/691] ACPICA: Fix memory leak if acpi_ps_get_next_field() fails
Date: Tue, 15 Oct 2024 13:26:04 +0200
Message-ID: <20241015112456.853759234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

[ Upstream commit e6169a8ffee8a012badd8c703716e761ce851b15 ]

ACPICA commit 1280045754264841b119a5ede96cd005bc09b5a7

If acpi_ps_get_next_field() fails, the previously created field list
needs to be properly disposed before returning the status code.

Link: https://github.com/acpica/acpica/commit/12800457
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Rename local variable to avoid compiler confusion ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index fd351074c6129..29239a569bfd7 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -25,6 +25,8 @@ acpi_ps_get_next_package_length(struct acpi_parse_state *parser_state);
 static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 						       *parser_state);
 
+static void acpi_ps_free_field_list(union acpi_parse_object *start);
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ps_get_next_package_length
@@ -683,6 +685,39 @@ static union acpi_parse_object *acpi_ps_get_next_field(struct acpi_parse_state
 	return_PTR(field);
 }
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ps_free_field_list
+ *
+ * PARAMETERS:  start               - First Op in field list
+ *
+ * RETURN:      None.
+ *
+ * DESCRIPTION: Free all Op objects inside a field list.
+ *
+ ******************************************************************************/
+
+static void acpi_ps_free_field_list(union acpi_parse_object *start)
+{
+	union acpi_parse_object *cur = start;
+	union acpi_parse_object *next;
+	union acpi_parse_object *arg;
+
+	while (cur) {
+		next = cur->common.next;
+
+		/* AML_INT_CONNECTION_OP can have a single argument */
+
+		arg = acpi_ps_get_arg(cur, 0);
+		if (arg) {
+			acpi_ps_free_op(arg);
+		}
+
+		acpi_ps_free_op(cur);
+		cur = next;
+	}
+}
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ps_get_next_arg
@@ -751,6 +786,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 			while (parser_state->aml < parser_state->pkg_end) {
 				field = acpi_ps_get_next_field(parser_state);
 				if (!field) {
+					if (arg) {
+						acpi_ps_free_field_list(arg);
+					}
+
 					return_ACPI_STATUS(AE_NO_MEMORY);
 				}
 
-- 
2.43.0



