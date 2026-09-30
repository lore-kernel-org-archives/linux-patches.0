Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D3B51118E;
	Wed, 30 Sep 2026 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782523; cv=none; b=YJ9VM8tV5gZHQYotPgj1+zbj3HFCkt5OhE4vecq5X+okmSMMsvx0pxSc6Xq5kAMmFmQpo3ptg4Gw1rlXUouTHroffMyhYDAawdTo29ilQl8LH1lvBKAXCv1uhPEiTrmpGqYrSKUI/+HXnnzdxOmHFwOcOUigQGvBhjoy4zFEohA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782523; c=relaxed/simple;
	bh=Virs7XdXyaQpJhQ7of/Xac3Xxm7c+5+N3Hh+NDkh8RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpEqYNX8P2MC6mf/0cfm1twsAvuJoWcCZc8na4hP9tDG0V5ju3jlNiln157eKs7EVLa3WL2OFmju/8/pyGFPz1Ftyu8KL5XNmF12RUfvFSiHjm5NlbBN0SrbLeJEwmLCg8g9MRR0kJ5Ovpv1wpd/BYXZJRgkVvPZ7RDEpUjIohU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TVPtcFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TVPtcFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F051F0089B;
	Wed, 30 Sep 2026 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782513;
	bh=Uk7fq4/QIYRVhwL8j9zQTl8p3i/8G31CaqjJNOhpXkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TVPtcFs+Ifh5yqQVd6lmWIIslA40khdycFd9GBNVDFYp2DW4UXq0Q/S6hgGurqi8
	 +CzGqpI/cdPxzaKen6yWUD5m0z1er0KkXS0UUmEI8B9OwdRTaYs2eogH6ijhT/Y9bL
	 LGI1j7WqQT2lbh7O4uoc+UUsD9NxwbZ221A8FcCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/595] ACPICA: Fix integer overflow in acpi_ex_opcode_3A_1T_1R() (mid_op)
Date: Wed, 30 Sep 2026 17:19:27 +0200
Message-ID: <20260930152349.328231041@linuxfoundation.org>
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
index 962929d4abbfc..8c4741440567a 100644
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



