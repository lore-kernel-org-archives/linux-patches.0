Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CEF3509F13;
	Wed, 30 Sep 2026 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782533; cv=none; b=kA8WympY9sBmToEpmjJPLq33oxzQuVayecNi5bO3WBYgjMIPjTVy0Rx2T9lY9Edf/vY6jQ5mT3D4FrXQoi4Hwna1F4apOCLYM3W/hviF7c7zuYzKzPCydZwmgRjXFhIWzF6Xaofwf24nqZIVf+W801HK8TkJ1HaGb7955bjupls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782533; c=relaxed/simple;
	bh=FMzHQhnPoIr4uuEmrD1sdEBIRDUxXsUBZIsp2SjRd3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss18d8F9+3ok58k20VWOnD5od4u2vahK4uwPRRqFQYmQdmULChWPQPjfk4/5fpLB2SGMDagMeJdyTne9MOixq9gK8zp/iBnLzJqwomlMhd3jFVvfEYPi9dM/8kB+AbjMHv9oXBBCNXEoCZROVwt/vznP/IXFjueqr08NKWfNmUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJrGitth; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJrGitth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BA91F00899;
	Wed, 30 Sep 2026 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782524;
	bh=ig9+c+gN/9RcIhNs17VZg3gFxjZk53egywkfSlXaoYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJrGitth8IQJtkS/grDeXr/KJ1W3V8IQJ9q50MB5klwtcXdWPiunpVU/Nk7sGZ/Ib
	 6S4a2P2Vua8unkXVRhdycYcJURgjq/mO/qFTRbrN9I6xpAK0+9P40Sdkvs9mfS0obG
	 M34WjG3vrpOT5ZVhZ0wkQohoSaulYxuxeHDq4RQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/595] ACPICA: Add validation for node in acpi_ns_build_normalized_path()
Date: Wed, 30 Sep 2026 17:19:31 +0200
Message-ID: <20260930152349.416163467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



