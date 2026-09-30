Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28283521222;
	Wed, 30 Sep 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790936; cv=none; b=bg8PN4n7+FyXnuhJR2aeEenJfQmoAQNblt+I87BUoT7cLvC+Z3MO3u5GEbc/dcEDE6vWo3Irhv4iXGGfL1nEmSizWdlZJYPAWoetl+qiJouTh3++QR1wOc8xMWsdEFy8zRyseZym4+Q6Lgl6e7Fwyfo9F49LxM+xTqFF4OQV7gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790936; c=relaxed/simple;
	bh=UWJNv0rSpwXpqRfUGGxIWjhWKQGgctdfeKwAKozdlMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJAjbuTidEEi0OFg3Wl0VSJOiuLUUPB6Xe6oQxzOMyuRQVGDe34EzaMNehmaTbUuF/3x83kf9Bo4bNrSRh81yJDmG2dYIHNyQFqZ/pG/G6uhQee48g05peXQvHiDfEVxY8DWbynjc4Jj/ICOC69wY5oVC3qy/XOBYILHxI62yDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTOdSmNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTOdSmNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F281F000FF;
	Wed, 30 Sep 2026 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790935;
	bh=1pOUgyK1zJSUZ2CCY3gAeHeJd8VcIrH9BuuLGNd8e3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTOdSmNe8YuZW8CblmAKCBvDMNg3oDwW6aP55Z0kNY7qXYQMtwLJ+rGu3QFodYPoJ
	 qOiLrgTqiFGQ/QG3rhxr5IKU0ATFJPu2HK3Ue17sUjvKbvf/UUTZXIO7KIY+SZ2EQm
	 Vwe270niDd50U/Vdw5gyiDG7UMheuu4jR7Hrxku0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/752] ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)
Date: Wed, 30 Sep 2026 17:19:11 +0200
Message-ID: <20260930152359.920035860@linuxfoundation.org>
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

[ Upstream commit 0e2021f49e64b3c8a9aa880d0c62a218bfe147ce ]

Add overflow check for Index + Length to prevent integer overflow
when calculating the truncation length. This prevents negative
size parameter being passed to memcpy().

Link: https://github.com/acpica/acpica/commit/d281ec1ac84e
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3760974.R56niFO833@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exoparg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/exoparg3.c b/drivers/acpi/acpica/exoparg3.c
index 109abf3e12fce..8ff4df1640817 100644
--- a/drivers/acpi/acpica/exoparg3.c
+++ b/drivers/acpi/acpica/exoparg3.c
@@ -152,7 +152,7 @@ acpi_status acpi_ex_opcode_3A_1T_1R(struct acpi_walk_state *walk_state)
 
 		/* Truncate request if larger than the actual String/Buffer */
 
-		else if ((index + length) > operand[0]->string.length) {
+		else if ((index + length) > operand[0]->string.length || (index + length) < index) {	/* Check for overflow */
 			length =
 			    (acpi_size)operand[0]->string.length -
 			    (acpi_size)index;
-- 
2.53.0



