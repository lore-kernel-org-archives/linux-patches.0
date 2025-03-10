Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8115623371B;
	Mon, 10 Mar 2025 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627913; cv=none; b=PEF821ZlxGJlfKZpdVsWjWvuhNh1WYkz7B05epRbNy0o710WtJq6uNR4pu5j7V1XA1lbXt1I1YtFR0/lRH9R8WPpCvdVfLQf9BNIPDmbOsUrKhl0jOa+CAC2U1Wx9E08y/7/vmwevJmi+igIpgdq4IWlsH7yJBgicNmAQAbM+rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627913; c=relaxed/simple;
	bh=GjmrvjU5cjD/aKs3pK1G+b3H9Vbn/hSa0zCw9UYWpHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq6vRNRI3u0WL5XdTmQVBRqxnACNJHC9YtHeb/hpjNbH0Hwt6v3w8ZP97m6idD1BI9SJ9t1hS18nzgiU8MkXvL62Sffl24Q6OjGpWPhVsvANknHzbjdXZtwA2hQnEIwrx905J5SYOAtp/ZcSzKDrDUKG4Waz7OyfU8XJe0Jv0JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQwprG3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQwprG3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BBFC4CEE5;
	Mon, 10 Mar 2025 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627913;
	bh=GjmrvjU5cjD/aKs3pK1G+b3H9Vbn/hSa0zCw9UYWpHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQwprG3GSF1qYCRXLQFq1bB1+RKKh4/AhegdLoXaUkt8whrIQ5mNAJHygoPzzHzox
	 C3ZiLBxfLY8qTGjolrLk5YRg374jsP9bXjXVltuMSI3MCIEqb0fpLiOYJ2DIc47eGr
	 iEhwrKqjOeSkdG3Hgtjd8KkBzwE4uUp4qbNLrvZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 023/145] Revert "of: reserved-memory: Fix using wrong number of cells to get property alignment"
Date: Mon, 10 Mar 2025 18:05:17 +0100
Message-ID: <20250310170435.673994475@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

commit 75f1f311d883dfaffb98be3c1da208d6ed5d4df9 upstream.

This reverts commit 267b21d0bef8e67dbe6c591c9991444e58237ec9.

Turns out some DTs do depend on this behavior. Specifically, a
downstream Pixel 6 DT. Revert the change at least until we can decide if
the DT spec can be changed instead.

Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_reserved_mem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -156,12 +156,12 @@ static int __init __reserved_mem_alloc_s
 
 	prop = of_get_flat_dt_prop(node, "alignment", &len);
 	if (prop) {
-		if (len != dt_root_size_cells * sizeof(__be32)) {
+		if (len != dt_root_addr_cells * sizeof(__be32)) {
 			pr_err("invalid alignment property in '%s' node.\n",
 				uname);
 			return -EINVAL;
 		}
-		align = dt_mem_next_cell(dt_root_size_cells, &prop);
+		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
 	}
 
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;


