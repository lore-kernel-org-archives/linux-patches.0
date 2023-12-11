Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD855101A;
	Mon, 11 Dec 2023 18:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXkbBukM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F8AC433C8;
	Mon, 11 Dec 2023 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319209;
	bh=ffzvnjyZKKrVCJwjiPu4lx8iobGJ21WOXpEJrsQY7/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXkbBukM9rzvxke4cpzMo4xbiZi+JrzPEd2y/rXkE+2h86wpI+N43MqoU/punqYb0
	 lZs10EDMtpf5lLe/J+7JNVoL15IxjGasLRNQE0iYvVWrpS/+PGKManw8a3+vEJcsKA
	 9c1YRyQNpT1fHD5regpPD+3qWeCPeUyA7I3LD2tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/244] dt: dt-extract-compatibles: Handle cfile arguments in generator function
Date: Mon, 11 Dec 2023 19:18:35 +0100
Message-ID: <20231211182046.787624389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit eb2139fc0da63b89a2ad565ecd8133a37e8b7c4f ]

Move the handling of the cfile arguments to a separate generator
function to avoid redundancy.

Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20230828211424.2964562-2-nfraprado@collabora.com
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 8f51593cdcab ("dt: dt-extract-compatibles: Don't follow symlinks when walking tree")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/dtc/dt-extract-compatibles | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/scripts/dtc/dt-extract-compatibles b/scripts/dtc/dt-extract-compatibles
index 9df9f1face832..2b6d228602e85 100755
--- a/scripts/dtc/dt-extract-compatibles
+++ b/scripts/dtc/dt-extract-compatibles
@@ -49,6 +49,14 @@ def print_compat(filename, compatibles):
 	else:
 		print(*compatibles, sep='\n')
 
+def files_to_parse(path_args):
+	for f in path_args:
+		if os.path.isdir(f):
+			for filename in glob.iglob(f + "/**/*.c", recursive=True):
+				yield filename
+		else:
+			yield f
+
 show_filename = False
 
 if __name__ == "__main__":
@@ -59,11 +67,6 @@ if __name__ == "__main__":
 
 	show_filename = args.with_filename
 
-	for f in args.cfile:
-		if os.path.isdir(f):
-			for filename in glob.iglob(f + "/**/*.c", recursive=True):
-				compat_list = parse_compatibles(filename)
-				print_compat(filename, compat_list)
-		else:
-			compat_list = parse_compatibles(f)
-			print_compat(f, compat_list)
+	for f in files_to_parse(args.cfile):
+		compat_list = parse_compatibles(f)
+		print_compat(f, compat_list)
-- 
2.42.0



