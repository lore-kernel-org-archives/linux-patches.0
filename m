Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BA61547F3;
	Mon, 14 Oct 2024 14:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916128; cv=none; b=fu8SdJC06ZP7aGVdOlO6Wkn9JwlvugQ7V4VCOAVAIPIxjN8ws3H46vD/2ecqzdvOvdNKG1N7kHuLiJMImtiniqcHfmymQkNqOzPnrTSzsa9sEDk21ZJgrCN+QInnW7jlGt3ZTZtIxzU+ESTn9SlQ8IcWIxUfrpuz7r4m11q+wvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916128; c=relaxed/simple;
	bh=Wx63BEMQO+i5hpOjeK4g4WsXr6oWJ+5/Hyf9hpAOWPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA/9Az0TNIe+TKA0eqKqEZPvjj0QvXZotQF+Y0lBbfqHujPAJjUNUupYYHH32DsI8qxLGvS1H/DvjaRN5aR/MTWA52EUHLvtb+xfayVxP6O6GpNvDsvO9LPugcUj7Nj3YYrNF7FLUvKrkdrtq7tByGvhi7P2+tdxW/g+KIUMGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nahcDaXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nahcDaXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A5BC4CEC3;
	Mon, 14 Oct 2024 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916128;
	bh=Wx63BEMQO+i5hpOjeK4g4WsXr6oWJ+5/Hyf9hpAOWPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nahcDaXTqAaaMX1O3QLTn4xAaU+vd9AurtmSoeTh5lLd8I78RCVKlD56YsNOjgZYG
	 xRB14gs5yNKvOetlYlKE+FVsALsvF+5kqgPR44/rKjq8wrX7TmFSiAnQRtPAlBdlQM
	 4e2ym7i/T1m6YrwlBf+p77VepqF6/CWwMXpimSm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 061/214] comedi: ni_routing: tools: Check when the file could not be opened
Date: Mon, 14 Oct 2024 16:18:44 +0200
Message-ID: <20241014141047.371486394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Ruffalo Lavoisier <ruffalolavoisier@gmail.com>

[ Upstream commit 5baeb157b341b1d26a5815aeaa4d3bb9e0444fda ]

- After fopen check NULL before using the file pointer use

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
Link: https://lore.kernel.org/r/20240906203025.89588-1-RuffaloLavoisier@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
index d55521b5bdcb2..892a66b2cea66 100644
--- a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
+++ b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
@@ -140,6 +140,11 @@ int main(void)
 {
 	FILE *fp = fopen("ni_values.py", "w");
 
+	if (fp == NULL) {
+		fprintf(stderr, "Could not open file!");
+		return -1;
+	}
+
 	/* write route register values */
 	fprintf(fp, "ni_route_values = {\n");
 	for (int i = 0; ni_all_route_values[i]; ++i)
-- 
2.43.0



