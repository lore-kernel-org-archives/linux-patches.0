Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFB74E9C3B;
	Thu, 17 Sep 2026 16:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664041; cv=none; b=XPFC+t81lsVw8zpqKbGD8eVmz1E+Qbbs1RDRkKEM9Ka9IDkpgtMAPxo1DK4GYWopiI9g/ToacV8g0vClKiFNY76Dg2o/tQpCPWa68vc3MRqHZqHEcWTN6DyQ6S39KIcdfSxDFRHd9ZgI+ogpJLMENiLUhnPfH+YrR6xnYYpT96E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664041; c=relaxed/simple;
	bh=6YTGiyYLU/JH3wEkuoIG5g65x4cjuTT9HwjLuX3MTZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDVCl9D7lnf8DIHTJqblolQ2NDjL8cQGho9Mj+A3c8GX1O+1gaEKnCZ3NhexKzXkNtV18B1BrtJqGKZl01Rwcw7M0Qyndp0QLK8RRozsTZoyW7F6siJwJBayyPZeBw/ckbz9r7x29rfLSUOgl+chaFnAlAKCYypWRIauMzp6WZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uu3ZA/so; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uu3ZA/so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B368E1F00893;
	Thu, 17 Sep 2026 16:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664040;
	bh=dQlHvdRRFRno4q6GG9c1PLUFRx1ang2t9ZDycdO8gtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uu3ZA/soK3N1ZTkUWcw0+W5TU4FzqsEudHs07wQ+7Z4D51CSkSEMWXezPfK1yk5uw
	 X4zSO8fh7EYT91cXukKzXfjvI4ICa570P3s53hGmvuZ+h1BJH0fTQsIVc9eX10Whnl
	 hA+230m+Cw+iuQkrYd8kP84B2vS+X3KfK18ngw7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0239/1250] ACPICA: Prevent adding invalid references
Date: Thu, 17 Sep 2026 16:00:34 +0100
Message-ID: <20260917151558.621488338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ikaros <void0red@gmail.com>

[ Upstream commit 6e8c55e13a5e3a9f38921d62924f18ceba3330eb ]

Prevent adding references for local, argument, and debug objects
in acpi_ut_copy_simple_object().

Link: https://github.com/acpica/acpica/commit/f576898d7814
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4511989.ejJDZkT8p0@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utcopy.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index 80458e70ac2bf..9ecf5c3f49ba6 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -731,7 +731,15 @@ acpi_ut_copy_simple_object(union acpi_operand_object *source_desc,
 			break;
 		}
 
-		acpi_ut_add_reference(source_desc->reference.object);
+		/*
+		 * Local/Arg/Debug references do not have a valid Object pointer
+		 * that can be referenced
+		 */
+		if ((source_desc->reference.class != ACPI_REFCLASS_LOCAL) &&
+		    (source_desc->reference.class != ACPI_REFCLASS_ARG) &&
+		    (source_desc->reference.class != ACPI_REFCLASS_DEBUG)) {
+			acpi_ut_add_reference(source_desc->reference.object);
+		}
 		break;
 
 	case ACPI_TYPE_REGION:
-- 
2.53.0



