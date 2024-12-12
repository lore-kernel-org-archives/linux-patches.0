Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3DE218594;
	Thu, 12 Dec 2024 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018419; cv=none; b=UCdH+ms6o9RtcJLXnQoJS366xMmlpX+8Ux9YCKM00SfRvAC9Bon+znH+/neMTljHCREKCX1rJBsrQPxDSTKePn1hXA0oouRN13pan/HHFVsmQQKiKyW9apkgohuwA3wzvWNXTdSpSBbL5xCeeWTLTD3LtPkPHOEEotr96K5OTY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018419; c=relaxed/simple;
	bh=OBevgeBIw+A1BGossCi51jOjAajAhPVQWa2baLnDEIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYMs9MLIpFI45DW2oW0ngGs+dbu8i57DweQxqkO7fXDjEcK23avKal21EIpoB4fvstakauHsFExwIdRnaoB5nxnAb54wEIGiOolOLlA4HwZso+Su5hHOKb5mqTImG9V5ZGijVQyBXhsURcfWMq6gf9iwXUgcnx2aARq6sOwn4D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAcP5lXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAcP5lXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5AEC4CECE;
	Thu, 12 Dec 2024 15:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018418;
	bh=OBevgeBIw+A1BGossCi51jOjAajAhPVQWa2baLnDEIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAcP5lXqWmEwZcDqZuwweJ0pPYIxywIqcRbNuZvK3Ls6f22wrJkJBlv3PGtDYOrt/
	 bTwonaE75wghOBQ4MeduIKOhyX2tCQawGznVSyTmror5q1U+ac1mJ/ucE+g2vxWyyK
	 b9qmthbrfn8RENBCNgp6mePFL7t5a10XTJqYNMX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Monaco <gmonaco@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/356] verification/dot2: Improve dot parser robustness
Date: Thu, 12 Dec 2024 16:00:05 +0100
Message-ID: <20241212144255.877357067@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 571f8b3f866a6d990a50fe5c89fe0ea78784d70b ]

This patch makes the dot parser used by dot2c and dot2k slightly more
robust, namely:
* allows parsing files with the gv extension (GraphViz)
* correctly parses edges with any indentation
    * used to work only with a single character (e.g. '\t')
Additionally it fixes a couple of warnings reported by pylint such as
wrong indentation and comparison to False instead of `not ...`

Link: https://lore.kernel.org/20241017064238.41394-2-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/dot2/automata.py | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/verification/dot2/automata.py b/tools/verification/dot2/automata.py
index baffeb960ff0b..bdeb98baa8b06 100644
--- a/tools/verification/dot2/automata.py
+++ b/tools/verification/dot2/automata.py
@@ -29,11 +29,11 @@ class Automata:
 
     def __get_model_name(self):
         basename = ntpath.basename(self.__dot_path)
-        if basename.endswith(".dot") == False:
+        if not basename.endswith(".dot") and not basename.endswith(".gv"):
             print("not a dot file")
             raise Exception("not a dot file: %s" % self.__dot_path)
 
-        model_name = basename[0:-4]
+        model_name = ntpath.splitext(basename)[0]
         if model_name.__len__() == 0:
             raise Exception("not a dot file: %s" % self.__dot_path)
 
@@ -68,9 +68,9 @@ class Automata:
     def __get_cursor_begin_events(self):
         cursor = 0
         while self.__dot_lines[cursor].split()[0] != "{node":
-           cursor += 1
+            cursor += 1
         while self.__dot_lines[cursor].split()[0] == "{node":
-           cursor += 1
+            cursor += 1
         # skip initial state transition
         cursor += 1
         return cursor
@@ -94,11 +94,11 @@ class Automata:
                 initial_state = state[7:]
             else:
                 states.append(state)
-                if self.__dot_lines[cursor].__contains__("doublecircle") == True:
+                if "doublecircle" in self.__dot_lines[cursor]:
                     final_states.append(state)
                     has_final_states = True
 
-                if self.__dot_lines[cursor].__contains__("ellipse") == True:
+                if "ellipse" in self.__dot_lines[cursor]:
                     final_states.append(state)
                     has_final_states = True
 
@@ -110,7 +110,7 @@ class Automata:
         # Insert the initial state at the bein og the states
         states.insert(0, initial_state)
 
-        if has_final_states == False:
+        if not has_final_states:
             final_states.append(initial_state)
 
         return states, initial_state, final_states
@@ -120,7 +120,7 @@ class Automata:
         cursor = self.__get_cursor_begin_events()
 
         events = []
-        while self.__dot_lines[cursor][1] == '"':
+        while self.__dot_lines[cursor].lstrip()[0] == '"':
             # transitions have the format:
             # "all_fired" -> "both_fired" [ label = "disable_irq" ];
             #  ------------ event is here ------------^^^^^
@@ -161,7 +161,7 @@ class Automata:
         # and we are back! Let's fill the matrix
         cursor = self.__get_cursor_begin_events()
 
-        while self.__dot_lines[cursor][1] == '"':
+        while self.__dot_lines[cursor].lstrip()[0] == '"':
             if self.__dot_lines[cursor].split()[1] == "->":
                 line = self.__dot_lines[cursor].split()
                 origin_state = line[0].replace('"','').replace(',','_')
-- 
2.43.0



