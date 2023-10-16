Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF3C262AC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duxJGBhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36098C433C7;
	Mon, 16 Oct 2023 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468237;
	bh=FT4ee56z2WRbANIU6kVLEBkfG61EHJSnlQOZvKfRuBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duxJGBhVqeBnG/qNyq94I6AipRZRr3FhyoE2wkMxYCABdOP/8y6fOPQC4qTaIq2/v
	 DHvwawv45kQODb+XcRw6Ir8qdZpOoB0985+85HXfoIv//An+pb+mkxy288ShAr9JH7
	 IjZAa7Wo03Jp6CoB/w12oerCSM4Ul24E04M1JhA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 188/191] ovl: fix regression in parsing of mount options with escaped comma
Date: Mon, 16 Oct 2023 10:42:53 +0200
Message-ID: <20231016084019.759657519@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit c34706acf40b43dd31f67c92c5a95d39666a1eb3 ]

Ever since commit 91c77947133f ("ovl: allow filenames with comma"), the
following example was legit overlayfs mount options:

  mount -t overlay overlay -o 'lowerdir=/tmp/a\,b/lower' /mnt

The conversion to new mount api moved to using the common helper
generic_parse_monolithic() and discarded the specialized ovl_next_opt()
option separator.

Bring back ovl_next_opt() and use vfs_parse_monolithic_sep() to fix the
regression.

Reported-by: Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
Closes: https://lore.kernel.org/r/8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu/
Fixes: 1784fbc2ed9c ("ovl: port to new mount api")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/params.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index c69d97aef2cf9..c0f70af422d6c 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -120,6 +120,34 @@ const struct fs_parameter_spec ovl_parameter_spec[] = {
 	{}
 };
 
+static char *ovl_next_opt(char **s)
+{
+	char *sbegin = *s;
+	char *p;
+
+	if (sbegin == NULL)
+		return NULL;
+
+	for (p = sbegin; *p; p++) {
+		if (*p == '\\') {
+			p++;
+			if (!*p)
+				break;
+		} else if (*p == ',') {
+			*p = '\0';
+			*s = p + 1;
+			return sbegin;
+		}
+	}
+	*s = NULL;
+	return sbegin;
+}
+
+static int ovl_parse_monolithic(struct fs_context *fc, void *data)
+{
+	return vfs_parse_monolithic_sep(fc, data, ovl_next_opt);
+}
+
 static ssize_t ovl_parse_param_split_lowerdirs(char *str)
 {
 	ssize_t nr_layers = 1, nr_colons = 0;
@@ -596,6 +624,7 @@ static int ovl_reconfigure(struct fs_context *fc)
 }
 
 static const struct fs_context_operations ovl_context_ops = {
+	.parse_monolithic = ovl_parse_monolithic,
 	.parse_param = ovl_parse_param,
 	.get_tree    = ovl_get_tree,
 	.reconfigure = ovl_reconfigure,
-- 
2.40.1



