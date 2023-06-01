Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179C1FBEA
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752DCC4339B;
	Thu,  1 Jun 2023 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625977;
	bh=fplDzVp6B3/ORRrKudlbN0BsEAEHoivu2HIEGJvfbaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LU4TZxJGj7WYA7uANWYXvQxYwJ6nuzotT+Ud4GOfPPwhb6C0WB5KycQeqN4Jes8aQ
	 CKQALuhKT50+MWTFLvciXEgMtsk2r+QhTjZ9t9Xy81TOUn8TmLwErUieiAA8Nnan0t
	 iX3SNvBlpLsvKEY8VY+NtXLgOJ39ew7ZuLANsGjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 19/45] cxl/port: Fix NULL pointer access in devm_cxl_add_port()
Date: Thu,  1 Jun 2023 14:21:15 +0100
Message-Id: <20230601131939.595852162@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Richter <rrichter@amd.com>

[ Upstream commit a70fc4ed20a6118837b0aecbbf789074935f473b ]

In devm_cxl_add_port() the port creation may fail and its associated
pointer does not contain a valid address. During error message
generation this invalid port address is used. Fix that wrong address
access.

Fixes: f3cd264c4ec1 ("cxl: Unify debug messages when calling devm_cxl_add_port()")
Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230519215436.3394532-1-rrichter@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 4d1f9c5b5029a..27cbf457416d2 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -751,11 +751,10 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 
 	parent_port = parent_dport ? parent_dport->port : NULL;
 	if (IS_ERR(port)) {
-		dev_dbg(uport, "Failed to add %s%s%s%s: %ld\n",
-			dev_name(&port->dev),
-			parent_port ? " to " : "",
+		dev_dbg(uport, "Failed to add%s%s%s: %ld\n",
+			parent_port ? " port to " : "",
 			parent_port ? dev_name(&parent_port->dev) : "",
-			parent_port ? "" : " (root port)",
+			parent_port ? "" : " root port",
 			PTR_ERR(port));
 	} else {
 		dev_dbg(uport, "%s added%s%s%s\n",
-- 
2.39.2



