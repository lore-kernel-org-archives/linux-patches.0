Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F114C51D524;
	Wed, 30 Sep 2026 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790817; cv=none; b=fm5NeMj59RSXESRQT7YZfTo3ZGiMMOpbBhvjBrORuxAIFkXHbt3pO6fTcwTq5b1aNdlTNg4GOqMk78C8fFZDzyGJxer45Q3w5sq3ePbhLTfzIMaukqCo1PqjpMvLi3fXdmZU3wITyQj/cBP8lT6kPX7yZDC8lIvU1T+PehEKfIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790817; c=relaxed/simple;
	bh=ZCYF+VcHUkZeZMWirEuO4noq9Wy2914YiPE8m0ik5Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do3Wj9XOCXEAdEoodYbxZ0LU++wmohwnZd5efNLBvTwCQN9ocOUvLdD9acEUJZfFLLh4Qe1Gh1dN3vOL6jtwmw1lH0Tmpf2YzO39aVmZiw5MjAt6rn5umZKjJIBu/+seqh2XpA21Lu2ZTR9IGAvTiwphpwRW05gft6uBe6sj7bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTtNKr3H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTtNKr3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59ECD1F00898;
	Wed, 30 Sep 2026 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790815;
	bh=tP680u4GgZnC+PVk7NBrNvy67bhv+bO9oWJ/cDYHJU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTtNKr3HgBjgiryP7cJ4F0c0qZPKVcPxVz4A3/DEFXzO0f+7ZBvatHpZbOS0it/vL
	 pqS0c9eiGM3BLO9U35eqVH+L2pY6Ug1eFSrdtW9OnYYaXgYWl9NtQt+Yk+NZbVBPyf
	 9AF6WTG/0IUGJ/poGsP74lnRM/BC5LKDAMSzTQ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/752] ACPICA: Add validation for node in acpi_ns_build_normalized_path()
Date: Wed, 30 Sep 2026 17:19:15 +0200
Message-ID: <20260930152400.007485061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ikaros <void0red@gmail.com>

[ Upstream commit 96b2b616870e46e2bc04efec03879683a0036e66 ]

Add validation for node in acpi_ns_build_normalized_path()
to prevent use-after-free vulnerabilities.

Link: https://github.com/acpica/acpica/commit/b35adf49e89a
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/118666237.nniJfEyVGO@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsnames.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/acpica/nsnames.c b/drivers/acpi/acpica/nsnames.c
index d91153f657005..ab6d217d31db4 100644
--- a/drivers/acpi/acpica/nsnames.c
+++ b/drivers/acpi/acpica/nsnames.c
@@ -222,6 +222,12 @@ acpi_ns_build_normalized_path(struct acpi_namespace_node *node,
 		goto build_trailing_null;
 	}
 
+	/* Validate the Node to avoid use-after-free vulnerabilities */
+
+	if (ACPI_GET_DESCRIPTOR_TYPE(node) != ACPI_DESC_TYPE_NAMED) {
+		goto build_trailing_null;
+	}
+
 	next_node = node;
 	while (next_node && next_node != acpi_gbl_root_node) {
 		if (next_node != node) {
-- 
2.53.0



