Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB431D8DEA;
	Tue, 15 Oct 2024 11:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993497; cv=none; b=MFmGEr86AyoYrN7q9oG4O4nw0KZn+O8YmcbisWbAs9X9hVPLIxmAntzd9OUiUojoY7lHcrpSxUlcdvcCFhWtAwrDcqjuP/QTWoes4qRTQ8WWM9ngdJrRhfSZN9LwdA+inrGMsAKvw95GNjI6rrOfa5DeWM9Rz5MZ+OYJah1qdOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993497; c=relaxed/simple;
	bh=usbjsHvD/rS7qPE3Hs3tzA1brR4l5aERjY10/FA2MYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmGsJWyIZz7JJQTv0slkiT3frR/7i9pWqZz+Agy04vtfH8uKI7BPqBrrpOGs/9noZda8Kd8/jJww68DtY20O6M/9yq3OZoXZd2vHCLU9SzSjD0coz2boUjTdlhOEXdW1w1VcVUtfg4LiNBbRIgPFTbVi3Qhs4oztvTghECJL5xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXPqvLky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXPqvLky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E21AC4CEC6;
	Tue, 15 Oct 2024 11:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993497;
	bh=usbjsHvD/rS7qPE3Hs3tzA1brR4l5aERjY10/FA2MYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXPqvLkyx5M7ukLJOSewid3EDnpyXvQvxEZcTCdq08+k9Rz6kiU1dD/g+temM9qPC
	 SkoUe4HmKZe0GjMYyxYKFDZmyrQG3PkUZyzlaAQIpd0kqT7K7XlukV5G59yWlpVbKR
	 B0U3Y6od8kvrcdBD+u2TlktsPY3ZGzOqMiC28gdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/691] ACPICA: iasl: handle empty connection_node
Date: Tue, 15 Oct 2024 13:26:18 +0200
Message-ID: <20241015112457.409224405@linuxfoundation.org>
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

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

[ Upstream commit a0a2459b79414584af6c46dd8c6f866d8f1aa421 ]

ACPICA commit 6c551e2c9487067d4b085333e7fe97e965a11625

Link: https://github.com/acpica/acpica/commit/6c551e2c
Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exprep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index d8c55dde191b1..8f143f377a3d3 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -437,6 +437,9 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
 
 		if (info->connection_node) {
 			second_desc = info->connection_node->object;
+			if (second_desc == NULL) {
+				break;
+			}
 			if (!(second_desc->common.flags & AOPOBJ_DATA_VALID)) {
 				status =
 				    acpi_ds_get_buffer_arguments(second_desc);
-- 
2.43.0



