Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0471E497;
	Thu, 23 May 2024 13:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470351; cv=none; b=tJb7UsPioBFmdL2lt8d/UGKXQ8PEZeO00OsaVhn1j12pluDiQd92TkOltlsAt12oVLlvtPJZcac+lgSODIUYJUW38srUejGttjGWNU82UlcontLG1cvlf5rz42vufb6CKqDxTweJH8xujuzAq/1BvHoIw7Rc6FRaHQ92eFl+Mn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470351; c=relaxed/simple;
	bh=uGVWeSYk/5RAHoFtLjmOifmJ5FmaLMeq7h3UDFqWa8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFzfWsTGkurm61YS2xNf/ATam+SNd1NIwtxcbYtCpp2PZsGZ+PqiMwx+94VLK6bAtAIkRC72djPTP3Od+aZ31INdQ6WhtM3wayEoWb+ahApuDKdb2SN9JoD6x0E5Vp3HAkqmHRUzachyKAaiQfi2J5r2ef77rtAbaRgE3E4o4UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPZsJ2Xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPZsJ2Xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E01C32786;
	Thu, 23 May 2024 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470351;
	bh=uGVWeSYk/5RAHoFtLjmOifmJ5FmaLMeq7h3UDFqWa8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPZsJ2Xk/lM1CCzwveddSrHwk7JP7JfXN6eKFnl9b4ToZe4HLK0AIi55joGVXnLh6
	 uas0RfQPmXMf/MdcfNeLCvX+Y5WksjUHOEBrDzHhrokeBH4+GqiMG5LCTLWTRkLdLb
	 DRO2TS9SYyzIjihVXSu3kmzQPO2lS9a9z/MpxP0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 23/23] docs: kernel_include.py: Cope with docutils 0.21
Date: Thu, 23 May 2024 15:13:19 +0200
Message-ID: <20240523130328.823590263@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akira Yokosawa <akiyks@gmail.com>

commit d43ddd5c91802a46354fa4c4381416ef760676e2 upstream.

Running "make htmldocs" on a newly installed Sphinx 7.3.7 ends up in
a build error:

    Sphinx parallel build error:
    AttributeError: module 'docutils.nodes' has no attribute 'reprunicode'

docutils 0.21 has removed nodes.reprunicode, quote from release note [1]:

  * Removed objects:

    docutils.nodes.reprunicode, docutils.nodes.ensure_str()
        Python 2 compatibility hacks

Sphinx 7.3.0 supports docutils 0.21 [2]:

kernel_include.py, whose origin is misc.py of docutils, uses reprunicode.

Upstream docutils removed the offending line from the corresponding file
(docutils/docutils/parsers/rst/directives/misc.py) in January 2022.
Quoting the changelog [3]:

    Deprecate `nodes.reprunicode` and `nodes.ensure_str()`.

    Drop uses of the deprecated constructs (not required with Python 3).

Do the same for kernel_include.py.

Tested against:
  - Sphinx 2.4.5 (docutils 0.17.1)
  - Sphinx 3.4.3 (docutils 0.17.1)
  - Sphinx 5.3.0 (docutils 0.18.1)
  - Sphinx 6.2.1 (docutils 0.19)
  - Sphinx 7.2.6 (docutils 0.20.1)
  - Sphinx 7.3.7 (docutils 0.21.2)

Link: http://www.docutils.org/RELEASE-NOTES.html#release-0-21-2024-04-09 [1]
Link: https://www.sphinx-doc.org/en/master/changes.html#release-7-3-0-released-apr-16-2024 [2]
Link: https://github.com/docutils/docutils/commit/c8471ce47a24 [3]
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/faf5fa45-2a9d-4573-9d2e-3930bdc1ed65@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/kernel_include.py |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/sphinx/kernel_include.py
+++ b/Documentation/sphinx/kernel_include.py
@@ -94,7 +94,6 @@ class KernelInclude(Include):
         # HINT: this is the only line I had to change / commented out:
         #path = utils.relative_path(None, path)
 
-        path = nodes.reprunicode(path)
         encoding = self.options.get(
             'encoding', self.state.document.settings.input_encoding)
         e_handler=self.state.document.settings.input_encoding_error_handler


