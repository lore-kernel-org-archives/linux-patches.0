Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D31133FE;
	Tue,  3 Dec 2024 15:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238085; cv=none; b=co41b74eelDuNkh75F8zNvFeDjNT1MMb3PnEIRmcsu1n9r+VOqeDRvbKv2qNB1cK5202R7kxMmnLaDNcazn04HRyYEmiu8wIaQJe2XWtXhFsCSAYKTAti14Zaj3HIReHgCKEIPunHPlMgOPE2Jc52Aiy103gUb26zcpX64pu0qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238085; c=relaxed/simple;
	bh=QJhiCAhNUTcP+RPiI3Q02tduZ0w0hmX7SWSpoyoxomE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj38F+UNfmuZ2qtdyelGXalSIrvzWbvguV4qSO+FvJYh1JNclkefk8HYCK5PysJ7UcTheONKctm3aeg0XSd/qyG0HE5+AtLkMA453pi/Ma22UNzpnjnl1dbXlmDwUOL5/CpkpqDndrrhxa/yvK/qdXotlopGsq686dGsj/XICqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+q44Qk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+q44Qk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEA1C4CECF;
	Tue,  3 Dec 2024 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238085;
	bh=QJhiCAhNUTcP+RPiI3Q02tduZ0w0hmX7SWSpoyoxomE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+q44Qk89QZ8nx1xxIk06IxvggPrzMnww2gCS1ihj4P/fr2xmAbRcwaOc3r+CarrU
	 UJxZSNuTuIWBwxt5G3+lC73SYtYPdnnF2MMNsFDHR6GK57CrdYgv+F2xrX5Wy6oEZ/
	 wKw+ApdztTYo9ibfAQC2IYawuYXI7Pd7tj0YV6fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 156/817] scripts/kernel-doc: Do not track section counter across processed files
Date: Tue,  3 Dec 2024 15:35:28 +0100
Message-ID: <20241203144001.815493409@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit be9264110e4e874622d588a75daf930539fdf6ea ]

The section counter tracks how many sections of kernel-doc were added.
The only real use of the counter value is to check if anything was
actually supposed to be output and give a warning is nothing is
available.

The current logic of remembering the initial value and then resetting
the value then when processing each file means that if a file has the
same number of sections as the previously processed one, a warning is
incorrectly given.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20241008082905.4005524-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kernel-doc | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 2791f81952038..c608820f0bf51 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2322,7 +2322,6 @@ sub process_inline($$) {
 
 sub process_file($) {
     my $file;
-    my $initial_section_counter = $section_counter;
     my ($orig_file) = @_;
 
     $file = map_filename($orig_file);
@@ -2360,8 +2359,7 @@ sub process_file($) {
     }
 
     # Make sure we got something interesting.
-    if ($initial_section_counter == $section_counter && $
-        output_mode ne "none") {
+    if (!$section_counter && $output_mode ne "none") {
         if ($output_selection == OUTPUT_INCLUDE) {
             emit_warning("${file}:1", "'$_' not found\n")
                 for keys %function_table;
-- 
2.43.0



